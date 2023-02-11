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
                        completion: @escaping (Result<Data?, NetworkError>) -> Void
    ) -> NetworkRequest {
        let request = session.request(target).response { response in
            completion(response.result.mapError { NetworkError.afError($0) })
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
    
    public func request(_ target: Target,
                        completion: @escaping (Result<String, NetworkError>) -> Void) -> NetworkRequest {
        let request = session.request(target).responseString { response in
            completion(response.result.mapError { NetworkError.afError($0) })
        }
        return NetworkRequestImpl(request: request)
    }
    
    @available(macOS 10.15, *)
    @available(iOS 13.0, *)
    public func request<T: Decodable>(_ target: Target,
                                      type: T.Type) -> AnyPublisher<Alamofire.DataResponse<T, NetworkError>, Never> {
        return session.request(target)
            .publishDecodable(type: T.self)
            .map { publisher in
                publisher.mapError { NetworkError.afError($0) }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
