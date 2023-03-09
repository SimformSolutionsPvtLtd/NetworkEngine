import Foundation
import Alamofire


/// Type of Errors thrown by Network Engine
/// The Alamofire errors are wrapped in case `NetworkError.afError`
public enum NetworkError: Error {
    
    /// Error thrown by alamofire
    /// - Parameters:
    ///     - afEror: The almofire error
    case afError(_ afEror: AFError)
    
    /// The error containing status code
    /// - Parameters:
    ///     - statusCode: The status code recieved from server side
    case statusCode(_ statusCode: Int)
    
    /// The custom body of the error
    /// - Parameters:
    ///     - data: The `Data` of the error, user needs to encode this data into appropriate server error model
    case serverError(_ data: Data)
    
    /// Prohibited URL encoding error, thrown when you try to use anything except `URLEncoding.httpBody` in
    /// `TargetType.requestCompositeParameters` case
    case prohibitedURLEncoding
    
    /// No active netwok connection error
    case noInternetConnection
    
    /// Thrown when URL parameter encoding faills in `TargetType.requestParameterEncodable`
    case encodableParameterFailure
}

extension NetworkError {
    
    ///  The localized description of the error
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
        case .encodableParameterFailure:
            return "Encodable parameter serialization failed"
        }
    }
    
    /// The underlytiying error (if exists)
    var underlyingError: Error? {
        switch self {
        case .afError(let error):
            return error.underlyingError
        case .prohibitedURLEncoding,
                .noInternetConnection,
                .serverError,
                .statusCode,
                .encodableParameterFailure:
            return nil
        }
    }
}
