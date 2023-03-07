import Foundation
import Alamofire

open class NetworkRequestInterceptor: RequestInterceptor {
    
    private var retryAttempts = 0
    private let refreshToken: (@escaping (Bool) -> Void) -> Void
    private let isNetworkReachable: () -> Bool
    
    public init(_ refreshToken: @escaping (@escaping (Bool) -> Void) -> Void,
                _ isNetworkReachable: @escaping () -> Bool) {
        self.refreshToken = refreshToken
        self.isNetworkReachable = isNetworkReachable
    }
    
    public func retry(_ request: Request,
                      for session: Session,
                      dueTo error: Error,
                      completion: @escaping (RetryResult) -> Void) {
        let statusCode = (request.task?.response as? HTTPURLResponse)?.statusCode
        retryCheck(statusCode: statusCode, completion: completion)
    }
    
    public func adapt(_ urlRequest: URLRequest,
                      for session: Session,
                      completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard isNetworkReachable() else {
            completion(.failure(NetworkError.noInternetConnection))
            return
        }
        completion(.success(urlRequest))
    }
    
    open func retryCheck(statusCode: Int?, completion: @escaping (RetryResult) -> Void) {
        guard retryAttempts < 3 else {
            retryAttempts = 0
            completion(.doNotRetry)
            return
        }
        retryAttempts += 1
        if statusCode == StatusCodes.internalServerError.rawValue {
            completion(.retryWithDelay(1))
        } else if statusCode == StatusCodes.unauthorized.rawValue {
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
