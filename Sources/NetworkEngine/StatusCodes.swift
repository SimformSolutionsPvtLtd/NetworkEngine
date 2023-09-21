
import Foundation

/// Enum representing the HTTP commonly used status codes.
public enum StatusCodes: Int {
    
    case parameterRequired = 400
    case unauthorized = 401
    case forbidden = 403
    case unProcessableEntity = 422
    case notFound = 404
    case unexpectedServerError = 500
    case internalServerError = 501
    
    /// Provides the range of successfully HTTP response codes
    static let successCodes = 200..<300
    /// Provides the range of successfully and redirection HTTP response code
    static let successAndRedirectCodes = 200..<400
}
