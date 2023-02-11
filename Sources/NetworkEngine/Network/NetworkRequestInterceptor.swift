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
        guard retryAttempts < 3 else {
            completion(.doNotRetry)
            retryAttempts = 0
            return
        }
        retryAttempts = +1
        guard let response = request.task?.response as? HTTPURLResponse else {
            completion(.doNotRetry)
            retryAttempts = 0
            return
        }
        if response.statusCode == StatusCodes.internalServerError.rawValue {
            completion(.retryWithDelay(1))
        } else if response.statusCode == StatusCodes.unauthorized.rawValue {
            refreshToken() { [weak self] tokenRefreshed in
                if !tokenRefreshed {
                    completion(.doNotRetry)
                    self?.retryAttempts = 0
                } else {
                    completion(.retryWithDelay(1))
                }
            }
        } else {
            completion(.doNotRetry)
            retryAttempts = 0
        }
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
}
