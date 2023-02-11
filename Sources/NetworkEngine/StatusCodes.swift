import Foundation

public enum StatusCodes: Int {
    
    case parameterRequired = 400
    case unauthorized = 401
    case forbidden = 403
    case unprocessableEntity = 422
    case notFound = 404
    case unexpectedServerError = 500
    case internalServerError = 501
    
    static let successCodes = 200..<300
    static let successAndRedirectCodes = 200..<400
}
