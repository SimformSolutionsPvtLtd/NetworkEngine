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
            case .failure(let afError):
                if case .responseSerializationFailed = afError,
                   let serverData = response.data {
                    completion(.failure(NetworkError.serverError(serverData)))
                    return
                }
                if let statusCode = response.response?.statusCode {
                    completion(.failure(NetworkError.statusCode(statusCode)))
                    return
                }
                if case .requestAdaptationFailed(let error) = afError,
                   let networkError = error as? NetworkError {
                    completion(.failure(networkError))
                } else {
                    completion(.failure(NetworkError.afError(afError)))
                }
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
            case .failure(let afError):
                if let statusCode = response.response?.statusCode {
                    completion(.failure(NetworkError.statusCode(statusCode)))
                    return
                }
                if case .requestAdaptationFailed(let error) = afError,
                   let networkError = error as? NetworkError {
                    completion(.failure(networkError))
                } else {
                    completion(.failure(NetworkError.afError(afError)))
                }
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
            case .failure(let afError):
                if case .responseSerializationFailed = afError,
                   let serverData = response.data {
                    completion(.failure(NetworkError.serverError(serverData)))
                    return
                }
                if let statusCode = response.response?.statusCode {
                    completion(.failure(NetworkError.statusCode(statusCode)))
                    return
                }
                if case .requestAdaptationFailed(let error) = afError,
                   let networkError = error as? NetworkError {
                    completion(.failure(networkError))
                } else {
                    completion(.failure(NetworkError.afError(afError)))
                }
            }
        }
        return NetworkRequestImpl(request: request)
    }
    
    // MARK: Combine methods
    
    @available(macOS 10.15, *)
    @available(iOS 13.0, *)
    public func request(_ target: Target) -> AnyPublisher<Result<String, NetworkError>, Never> {
        return session.request(target)
            .publishString()
            .map { response in
                let newResult: Result<String, NetworkError>
                switch response.result {
                case .success(let data):
                    newResult = .success(data)
                case .failure(let afError):
                    if let statusCode = response.response?.statusCode {
                        newResult = .failure(NetworkError.statusCode(statusCode))
                        break
                    }
                    if case .requestAdaptationFailed(let error) = afError,
                       let networkError = error as? NetworkError {
                        newResult = .failure(networkError)
                    } else {
                        newResult = .failure(NetworkError.afError(afError))
                    }
                }
                return newResult
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    @available(macOS 10.15, *)
    @available(iOS 13.0, *)
    public func request(_ target: Target) -> AnyPublisher<Result<Data?, NetworkError>, Never> {
        return session.request(target)
            .publishUnserialized()
            .map { response in
                let newResult: Result<Data?, NetworkError>
                switch response.result {
                case .success(let data):
                    newResult = .success(data)
                case .failure(let afError):
                    if let statusCode = response.response?.statusCode {
                        newResult = .failure(NetworkError.statusCode(statusCode))
                        break
                    }
                    if case .requestAdaptationFailed(let error) = afError,
                       let networkError = error as? NetworkError {
                        newResult = .failure(networkError)
                    } else {
                        newResult = .failure(NetworkError.afError(afError))
                    }
                }
                return newResult
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    @available(macOS 10.15, *)
    @available(iOS 13.0, *)
    public func request<T: Decodable>(_ target: Target,
                                      type: T.Type) -> AnyPublisher<Result<T, NetworkError>, Never> {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = target.keyDecodingStrategy
        return session.request(target)
            .publishDecodable(type: T.self, decoder: decoder)
            .map { response in
                let newResult: Result<T, NetworkError>
                switch response.result {
                case .success(let data):
                    newResult = .success(data)
                case .failure(let afError):
                    if case .responseSerializationFailed = afError,
                       let serverData = response.data {
                        newResult = .failure(NetworkError.serverError(serverData))
                        break
                    }
                    if let statusCode = response.response?.statusCode {
                        newResult = .failure(NetworkError.statusCode(statusCode))
                        break
                    }
                    if case .requestAdaptationFailed(let error) = afError,
                       let networkError = error as? NetworkError {
                        newResult = .failure(networkError)
                    } else {
                        newResult = .failure(NetworkError.afError(afError))
                    }
                }
                return newResult
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
