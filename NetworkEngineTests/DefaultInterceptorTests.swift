
import XCTest
import Alamofire

@testable import NetworkEngine

class DefaultInterceptorTests: XCTestCase {
    
    var sut: DefaultInterceptor!
    var tokenRefreshed: Bool!
    var networkAccessible: Bool!
    var session: Session!
    var urlRequest: URLRequest!
    
    override func setUpWithError() throws {
        sut = DefaultInterceptor(refreshToken, isNetworkAccessible)
        tokenRefreshed = false
        networkAccessible = false
        session = Session()
        urlRequest = URLRequest(url: URL(string: "www.google.com")!)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testRequestAdaptation() throws {
        // When
        networkAccessible = true
        sut.adapt(urlRequest, for: session) { result in
            // Then
            switch result {
            case .success:
                XCTAssert(true)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
        
        // When
        networkAccessible = false
        sut.adapt(urlRequest, for: session) { result in
            // Then
            switch result {
            case .success:
                XCTAssert(false)
            case .failure(let error):
                let netwrokError = error as? NetworkError
                XCTAssertNotNil(netwrokError)
                var isNoInternetError = false
                if case NetworkError.noInternetConnection = netwrokError! {
                    isNoInternetError = true
                }
                XCTAssert(isNoInternetError)
            }
        }
    }
    
    func testRequestRetirer() throws {
        // Given
        networkAccessible = true
        
        // When
        // Unauthorized, should retry up to 3 times
        tokenRefreshed = true
        for i in 0...3 {
            sut.checkAndRetry(statusCode: StatusCodes.unauthorized.rawValue) { retryResult in
                // Then
                switch retryResult {
                case .retry, .doNotRetryWithError, .retryWithDelay:
                    XCTAssert(i != 3)
                case .doNotRetry:
                    XCTAssert(i == 3)
                }
            }
        }
        
        // When
        // Internal server error, should retrun up to 3 times
        for i in 0...3 {
            sut.checkAndRetry(statusCode: StatusCodes.internalServerError.rawValue) { retryResult in
                // Then
                switch retryResult {
                case .retry, .doNotRetryWithError, .retryWithDelay:
                    XCTAssert(i != 3)
                case .doNotRetry:
                    XCTAssert(i == 3)
                }
            }
        }
    }
    
    private func refreshToken(apiCall: (Bool) -> Void) {
        apiCall(tokenRefreshed)
    }
    
    private func isNetworkAccessible() -> Bool {
        return networkAccessible
    }
}
