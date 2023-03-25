import Foundation
import Alamofire

/// Defines the target type for the network call
public protocol TargetType: URLRequestConvertible, URLConvertible {
    
    /// The target's base `URL`.
    var baseURL: URL { get }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }

    /// The HTTP method used in the request.
    var method: Method { get }
    
    /// The key decoding stratergy to use when decoding reponse data
    var keyDecodingStrategy: KeyDecodingStrategy { get }

    /// The headers to be used in the request.
    var headers: [String: String]? { get }
    
    /// The Network task to be performed.
    var task: NetworkTask { get }
}

extension TargetType {
    
    public func asURL() throws -> URL {
        return Foundation.URL(target: self)
    }
    
    public func asURLRequest() throws -> URLRequest {
        let requestURL = Foundation.URL(target: self)

        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = self.headers

        switch task {
        case .requestPlain, .uploadFile, .uploadMultipart, .downloadDestination:
            return request
        case .requestData(let data):
            request.httpBody = data
            return request
        case let .requestJSONEncodable(encodable):
            return try request.encoded(encodable: encodable)
        case let .requestCustomJSONEncodable(encodable, encoder: encoder):
            return try request.encoded(encodable: encodable, encoder: encoder)
        case let .requestParameterEncodable(encodable):
            return try request.encoded(parameters: encodable.asDictionary(),
                                       parameterEncoding: URLEncoding.queryString)
        case let .requestParameters(parameters, parameterEncoding):
            return try request.encoded(parameters: parameters, parameterEncoding: parameterEncoding)
        case let .uploadCompositeMultipart(_, urlParameters):
            let parameterEncoding = URLEncoding(destination: .queryString)
            return try request.encoded(parameters: urlParameters, parameterEncoding: parameterEncoding)
        case let .downloadParameters(parameters, parameterEncoding, _):
            return try request.encoded(parameters: parameters, parameterEncoding: parameterEncoding)
        case let .requestCompositeData(bodyData: bodyData, urlParameters: urlParameters):
            request.httpBody = bodyData
            let parameterEncoding = URLEncoding(destination: .queryString)
            return try request.encoded(parameters: urlParameters, parameterEncoding: parameterEncoding)
        case let .requestCompositeParameters(bodyParameters: bodyParameters, urlParameters: urlParameters):
            let bodyfulRequest = try request.encoded(parameters: bodyParameters,
                                                     parameterEncoding: URLEncoding.httpBody)
            let urlEncoding = URLEncoding(destination: .queryString)
            return try bodyfulRequest.encoded(parameters: urlParameters, parameterEncoding: urlEncoding)
        }
    }
}
