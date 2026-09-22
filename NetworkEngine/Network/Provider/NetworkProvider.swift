
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
    
    public func requestString(_ target: Target) -> StringRequestTask {
        let request = session.buildRequest(target: target).validate()
        return StringRequestTaskImplementation(dataRequest: request)
    }
    
    public func requestData(_ target: Target) -> DataRequestTask {
        let request = session.buildRequest(target: target).validate()
        return DataRequestTaskImplementation(dataRequest: request)
    }
    
    public func requestDecodable(_ target: Target) -> DecodableRequestTask {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = target.keyDecodingStrategy
        let request = session.buildRequest(target: target).validate()
        return DecodableRequestTaskImplementation(dataRequest: request, decoder: decoder)
    }
    
    public func upload(_ target: Target,
                       progressHandler: ProgressHandler? = nil) -> UploadTask {
        var request = session.buildRequest(target: target).validate()
        if let progressHandler = progressHandler {
            request = request.uploadProgress(closure: progressHandler)
        }
        return UploadTaskImplementation(request: request)
    }
    
    public func download(_ target: Target, progressHandler: ProgressHandler?) -> DownloadTask {
        var request = session.buildDownloadRequest(target: target).validate()
        if let progressHandler = progressHandler {
            request = request.downloadProgress(closure: progressHandler)
        }
        return DownloadTaskImplementation(request: request)
    }
}

extension NetworkProvider {
    
    public func request(_ target: Target,
                        completion: @escaping (Result<String, NetworkError>) -> Void) {
        requestString(target).request(completion: completion)
    }
    
    public func request(_ target: Target,
                        completion: @escaping (Result<Data?, NetworkError>) -> Void) {
        requestData(target).request(completion: completion)
    }
    
    public func request<T: Decodable>(_ target: Target,
                                      type: T.Type,
                                      completion: @escaping (Result<T, NetworkError>) -> Void) {
        requestDecodable(target).request(type: type, completion: completion)
    }
    
    public func upload(_ target: Target,
                       progressHandler: ProgressHandler? = nil,
                       completion: @escaping (Result<Data?, NetworkError>) -> Void) {
        upload(target, progressHandler: progressHandler).upload(completion: completion)
    }
}
