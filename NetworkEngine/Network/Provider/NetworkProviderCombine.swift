
import Foundation
import Combine

// MARK: Combine methods
/// This extension provide publisher based combine support to `NetworkProvider`
@available(macOS 10.15, *)
@available(iOS 13.0, *)
extension NetworkProvider: NetworkProviderTypeCombine {

    public func request(_ target: Target) -> AnyPublisher<Result<String, NetworkError>, Never> {
        return session.buildRequest(target: target)
            .validate()
            .publishString()
            .map { $0.mappedResult }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    public func request(_ target: Target) -> AnyPublisher<Result<Data?, NetworkError>, Never> {
        return session.buildRequest(target: target)
            .validate()
            .publishUnserialized()
            .map { $0.mappedResult }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    public func request<T: Decodable>(_ target: Target,
                                      type: T.Type) -> AnyPublisher<Result<T, NetworkError>, Never> {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = target.keyDecodingStrategy
        return session.buildRequest(target: target)
            .validate()
            .publishDecodable(type: T.self, decoder: decoder)
            .map { $0.mappedResult }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    public func upload(_ target: Target,
                       progressHandler: ProgressHandler?) -> AnyPublisher<Result<Data, NetworkError>, Never> {
        var request = session.buildRequest(target: target).validate()
        if let progressHandler = progressHandler {
            request = request.uploadProgress(closure: progressHandler)
        }
        return request.publishData()
            .map { $0.mappedResult }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    public func download(_ target: Target,
                         progressHandler: ProgressHandler?) -> AnyPublisher<Result<URL, NetworkError>, Never> {
        var request = session.buildDownloadRequest(target: target).validate()
        if let progressHandler = progressHandler {
            request = request.downloadProgress(closure: progressHandler)
        }
        return request.publishURL()
            .map { $0.mappedResult }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    public func download(_ target: Target,
                         progressHandler: ProgressHandler?) -> AnyPublisher<Result<Data, NetworkError>, Never> {
        var request = session.buildDownloadRequest(target: target).validate()
        if let progressHandler = progressHandler {
            request = request.downloadProgress(closure: progressHandler)
        }
        return request.publishData()
            .map { $0.mappedResult }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
