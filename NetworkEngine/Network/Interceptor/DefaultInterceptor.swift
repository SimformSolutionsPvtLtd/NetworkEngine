
import Foundation
import Alamofire

/// Default implementation of `NetworkRequestInterceptor` with default handling of retry handler.
/// The adapt method checks for the network availability before making any API call,
/// if network is unavailable, it throws `NetworkError.noInternetConnection` error
public class DefaultInterceptor {
    
    // MARK: Private vars
    private var retryAttempts = 0
    private let refreshToken: (@escaping (Bool) -> Void) -> Void

    // MARK: Initialization
    public init(_ refreshToken: @escaping (@escaping (Bool) -> Void) -> Void) {
        self.refreshToken = refreshToken
    }
    
    /// Checks for a retry attempts based on given status codes, if current conditions satisfy for retry the attempts retry via `completion`
    /// - Parameters:
    ///     - statusCode: The status code received on the response of the network call
    ///     - completion: The completion block to call with the `RetryResult`
    func checkAndRetry(statusCode: Int?, completion: @escaping (RetryResult) -> Void) {
        guard retryAttempts < 3 else {
            retryAttempts = 0
            completion(.doNotRetry)
            return
        }
        retryAttempts += 1
        if statusCode == StatusCodes.internalServerError.rawValue {
            completion(.retryWithDelay(1))
        } else if statusCode == StatusCodes.unAuthorized.rawValue {
            refreshToken() { [weak self] tokenRefreshed in
                if !tokenRefreshed {
                    self?.retryAttempts = 0
                    completion(.doNotRetry)
                } else {
                    completion(.retryWithDelay(1))
                }
            }
        } else {
            retryAttempts = 0
            completion(.doNotRetry)
        }
    }
}

// MARK: NetworkRequestInterceptor
extension DefaultInterceptor: NetworkRequestInterceptor {

    public func retry(_ request: Request,
                      for session: Session,
                      dueTo error: Error,
                      completion: @escaping (RetryResult) -> Void) {
        let statusCode = (request.task?.response as? HTTPURLResponse)?.statusCode
        checkAndRetry(statusCode: statusCode, completion: completion)
    }

    public func adapt(_ urlRequest: URLRequest,
                      for session: Session,
                      completion: @escaping (Result<URLRequest, Error>) -> Void) {
        completion(.success(urlRequest))
    }
}
