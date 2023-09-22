
import Foundation

extension Encodable {
    
    /// Converts self to a dictionary
    /// - Returns: The converted dictionary
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            // Here throwing a network error as this failure would result in to unsuccessful request formation
            throw NetworkError.encodableParameterFailure
        }
        return dictionary
    }
}
