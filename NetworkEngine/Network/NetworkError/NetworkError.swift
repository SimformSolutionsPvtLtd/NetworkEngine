
import Foundation
import Alamofire

/// Type of Errors thrown by Network Engine
public enum NetworkError: LocalizedError {
    
    /// Alamofire error wrapped with additional information
    ///  - Parameters:
    ///     - error: The underlying error
    ///     - response: The `HTTPURLResponse`
    ///     - data: The data present in the response
    case networkError(_ error: AFError, _ response: HTTPURLResponse?, _ data: Data?)
    
    /// Thrown when URL parameter encoding fails in `TargetType.requestParameterEncodable`
    /// - Parameters:
    ///     - error: The underlying error
    case encodableParameterFailure(error: Error)
    
    /// Json to Dictionary conversion failed for URL parameter encoding
    case jsonDictionaryConversionFailed
}

extension NetworkError {
    
    ///  The description of the error
    var errorDescription: String {
        switch self {
        case .encodableParameterFailure(let error):
            return error.localizedDescription
        case .networkError(let error, _, _):
            return error.localizedDescription
        case .jsonDictionaryConversionFailed:
            return "Failed to convert Json to Dictionary for URL parameter encoding"
        }
    }
    
    /// The underlying error (if exists)
    var underlyingError: Error? {
        switch self {
        case .encodableParameterFailure(let error):
            return error
        case .networkError(let error, _, _):
            return error
        case .jsonDictionaryConversionFailed:
            return nil
        }
    }
}
