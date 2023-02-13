import Foundation
import Alamofire
import Combine

public struct NetworkProvider<Target: TargetType>: NetworkProviderType {
    
    public typealias Target = Target
    private let session: Session
    
    public init(interceptor: NetworkRequestInterceptor) {
        self.session = Session(interceptor: interceptor)
    }
    
    public func request(_ target: Target,
                        completion: @escaping (Result<String, NetworkError>) -> Void) -> NetworkRequest {
        let request = session.request(target).responseString { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                if case .responseSerializationFailed = error,
                   let serverData = response.data {
                    completion(.failure(NetworkError.serverError(serverData)))
                    return
                }
                if let statusCode = response.response?.statusCode {
                    completion(.failure(NetworkError.statusCode(statusCode)))
                    return
                }
                completion(.failure(NetworkError.afError(error)))
            }
        }
        return NetworkRequestImpl(request: request)
    }
    
    public func request(_ target: Target,
                        completion: @escaping (Result<Data?, NetworkError>) -> Void
    ) -> NetworkRequest {
        let request = session.request(target).response { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                if let statusCode = response.response?.statusCode {
                    completion(.failure(NetworkError.statusCode(statusCode)))
                    return
                }
                completion(.failure(NetworkError.afError(error)))
            }
        }
        return NetworkRequestImpl(request: request)
    }
    
    public func request<T: Decodable>(_ target: Target,
                                      type: T.Type,
                                      completion: @escaping (Result<T, NetworkError>) -> Void) -> NetworkRequest {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = target.keyDecodingStrategy
        let request = session.request(target).responseDecodable(decoder: decoder) { (response: AFDataResponse<T>) in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                if case .responseSerializationFailed = error,
                   let serverData = response.data {
                    completion(.failure(NetworkError.serverError(serverData)))
                    return
                }
                if let statusCode = response.response?.statusCode {
                    completion(.failure(NetworkError.statusCode(statusCode)))
                    return
                }
                completion(.failure(NetworkError.afError(error)))
            }
        }
        return NetworkRequestImpl(request: request)
    }
    
    // MARK: Combine methods
    
    @available(macOS 10.15, *)
    @available(iOS 13.0, *)
    public func request(_ target: Target) -> AnyPublisher<String, NetworkError> {
        return session.request(target)
            .publishString()
            .value()
            .mapError({
                NetworkError.afError($0)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    @available(macOS 10.15, *)
    @available(iOS 13.0, *)
    public func request(_ target: Target) -> AnyPublisher<Data?, NetworkError> {
        return session.request(target)
            .publishUnserialized()
            .value()
            .mapError({
                NetworkError.afError($0)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    @available(macOS 10.15, *)
    @available(iOS 13.0, *)
    public func request<T: Decodable>(_ target: Target,
                                      type: T.Type) -> AnyPublisher<T, NetworkError> {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = target.keyDecodingStrategy
        return session.request(target)
            .publishDecodable(type: T.self, decoder: decoder)
            .value()
            .mapError({
                NetworkError.afError($0)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
