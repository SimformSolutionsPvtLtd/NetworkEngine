
import Foundation
import Combine

// MARK: Combine methods
/// This extension provide publisher based combine support to `NetworkProvider`
extension NetworkProvider: NetworkProviderTypeCombine {

    public func request(_ target: Target) -> AnyPublisher<Result<String, NetworkError>, Never> {
        return requestString(target).request()
    }

    public func request(_ target: Target) -> AnyPublisher<Result<Data?, NetworkError>, Never> {
        return requestData(target).request()
    }

    public func request<T: Decodable>(_ target: Target,
                                      type: T.Type) -> AnyPublisher<Result<T, NetworkError>, Never> {
        return requestDecodable(target).request(type: type)
    }
    
    public func upload(_ target: Target,
                       progressHandler: ProgressHandler?) -> AnyPublisher<Result<Data, NetworkError>, Never> {
        return upload(target, progressHandler: progressHandler).upload()
    }
}
