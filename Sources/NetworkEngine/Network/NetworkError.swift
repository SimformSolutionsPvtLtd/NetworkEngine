import Foundation
import Alamofire

public enum NetworkError: Error {
    case afError(_ afEror: AFError)
    case statusCode(_ statusCode: Int)
    case serverError(_ data: Data)
    case prohibitedURLEncoding
    case noInternetConnection
}

extension NetworkError {
    
    var localizedDescription: String {
        switch self {
        case .afError(let error):
            return error.localizedDescription
        case .prohibitedURLEncoding:
            return "Only URLEncoding that `bodyEncoding` accepts is URLEncoding.httpBody. Others like `default`, `queryString` or `methodDependent` are prohibited - if you want to use them, add your parameters to `urlParameters` instead."
        case .noInternetConnection:
            return "No Internet connectivity"
        case .serverError(let data):
            return "Server error \(data)"
        case .statusCode(let statusCode):
            return "Server error code \(statusCode)"
        }
    }
    
    var underlyingError: Error? {
        switch self {
        case .afError(let error):
            return error.underlyingError
        case .prohibitedURLEncoding, .noInternetConnection, .serverError, .statusCode:
            return nil
        }
    }
}
