import Foundation

internal extension URLRequest {

    mutating func encoded(encodable: Encodable, encoder: JSONEncoder = JSONEncoder()) throws -> URLRequest {
        httpBody = try encoder.encode(encodable)
        return self
    }

    func encoded(parameters: [String: Any], parameterEncoding: ParameterEncoding) throws -> URLRequest {
        return try parameterEncoding.encode(self, with: parameters)
    }
}
