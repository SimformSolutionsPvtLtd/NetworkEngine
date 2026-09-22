
import XCTest
import Alamofire

@testable import NetworkEngine

class DefaultInterceptorTests: XCTestCase {
    
    var sut: DefaultInterceptor!
    var tokenRefreshed: Bool!
    var session: Session!
    var urlRequest: URLRequest!

    override func setUpWithError() throws {
        sut = DefaultInterceptor(refreshToken)
        tokenRefreshed = false
        session = Session()
        urlRequest = URLRequest(url: URL(string: "www.google.com")!)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testRequestRetirer() throws {
        // When
        // Unauthorized, should retry up to 3 times
        tokenRefreshed = true
        for i in 0...3 {
            sut.checkAndRetry(statusCode: StatusCodes.unAuthorized.rawValue) { retryResult in
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
}
