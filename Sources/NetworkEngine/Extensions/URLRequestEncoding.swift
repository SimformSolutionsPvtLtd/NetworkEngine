
import Foundation

internal extension URLRequest {
    
    /// Set the given `encodable` as request body by encoding it using given `encoder`
    /// - Parameters:
    ///   - encodable: The `Encodable`
    ///   - encoder: The `JSONEncoder`
    /// - Returns: The `URLRequest`
    mutating func encoded(encodable: Encodable, encoder: JSONEncoder = JSONEncoder()) throws -> URLRequest {
        httpBody = try encoder.encode(encodable)
        return self
    }
    
    /// Encode the given `parameters` using given `parameterEncoding`
    /// - Parameters:
    ///   - parameters: The parameters
    ///   - parameterEncoding: The `ParameterEncoding`
    /// - Returns: The `URLRequest`
    func encoded(parameters: [String: Any], parameterEncoding: ParameterEncoding) throws -> URLRequest {
        return try parameterEncoding.encode(self, with: parameters)
    }
}
