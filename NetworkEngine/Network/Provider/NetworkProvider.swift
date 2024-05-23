
import Foundation
import Alamofire
import Combine

/// NetworkProviderType implementation based on the given `TargetType`
/// This struct holds the responsibility to make the network calls and provide the desired response.
/// The network calls are implemented using Alamofire
public struct NetworkProvider<Target: TargetType>: NetworkProviderType {    
    
    /// The type of target
    public typealias Target = Target
    
    /// Session on which network calls are made
    internal let session: Session
    
    public init(interceptor: NetworkRequestInterceptor,
                configuration: URLSessionConfiguration = URLSessionConfiguration.af.default) {
        self.session = Session(configuration: configuration, interceptor: interceptor)
    }
    
    public func request(_ target: Target,
                        completion: @escaping (Result<String, NetworkError>) -> Void) -> NetworkRequest {
        let request = session.buildRequest(target: target)
            .validate()
            .responseString { completion($0.mappedResult) }
        return SimpleNetworkRequest(request: request)
    }
    
    public func request(_ target: Target,
                        completion: @escaping (Result<Data?, NetworkError>) -> Void) -> NetworkRequest {
        let request = session.buildRequest(target: target)
            .validate()
            .response { completion($0.mappedResult) }
        return SimpleNetworkRequest(request: request)
    }
    
    public func request<T: Decodable>(_ target: Target,
                                      type: T.Type,
                                      completion: @escaping (Result<T, NetworkError>) -> Void) -> NetworkRequest {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = target.keyDecodingStrategy
        let request = session.buildRequest(target: target)
            .validate()
            .responseDecodable(decoder: decoder) { completion($0.mappedResult) }
        return SimpleNetworkRequest(request: request)
    }
    
    public func upload(_ target: Target,
                       progressHandler: ProgressHandler? = nil,
                       completion: @escaping (Result<Data?, NetworkError>) -> Void) -> NetworkRequest {
        var request = session.buildRequest(target: target).validate()
        if let progressHandler = progressHandler {
            request = request.uploadProgress(closure: progressHandler)
        }
        request.response { completion($0.mappedResult) }
        return SimpleNetworkRequest(request: request)
    }
    
    public func download(_ target: Target,
                         progressHandler: ProgressHandler? = nil,
                         completion: @escaping (Result<URL?, NetworkError>) -> Void) -> NetworkRequest {
        var request = session.buildDownloadRequest(target: target).validate()
        if let progressHandler = progressHandler {
            request = request.downloadProgress(closure: progressHandler)
        }
        request.response { completion($0.mappedResult) }
        return SimpleNetworkRequest(request: request)
    }
    
    public func download(_ target: Target,
                         progressHandler: ProgressHandler? = nil,
                         completion: @escaping (Result<Data, NetworkError>) -> Void) -> NetworkRequest {
        var request = session.buildDownloadRequest(target: target).validate()
        if let progressHandler = progressHandler {
            request = request.downloadProgress(closure: progressHandler)
        }
        request.responseData { completion($0.mappedResult) }
        return SimpleNetworkRequest(request: request)
    }
}
