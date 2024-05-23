
import Foundation

extension Encodable {
    
    /// Converts self to a dictionary
    /// - Returns: The converted dictionary
    func asDictionary() throws -> [String: Any] {
        do {
            let data = try JSONEncoder().encode(self)
            guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                throw NetworkError.jsonDictionaryConversionFailed
            }
            return json
        } catch let error {
            throw NetworkError.encodableParameterFailure(error: error)
        }
    }
}
