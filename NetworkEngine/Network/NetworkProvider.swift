import Foundation
import Alamofire
import Combine

/// NetworkProviderType implementation based on the given `TargetType`
/// This struct holds the reponsibility to make the network calls and provide the desired response.
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
        let request = session.buildRequest(target: target).responseString { response in
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
        let request = session.buildRequest(target: target).response { response in
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
        let request = session.buildRequest(target: target).responseDecodable(decoder: decoder) { (response: AFDataResponse<T>) in
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
    
    public func upload(_ target: Target,
                       progressHandler: ProgressHandler? = nil,
                       completion: @escaping (Result<Data?, NetworkError>) -> Void) -> NetworkRequest {
        var request = session.buildRequest(target: target)
        if let progressHandler = progressHandler {
            request = request.uploadProgress(closure: progressHandler)
        }
        request.response { uploadResponse in
            switch uploadResponse.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let afError):
                if let statusCode = uploadResponse.response?.statusCode {
                    completion(.failure(NetworkError.statusCode(statusCode)))
                    return
                }
                completion(.failure(NetworkError.afError(afError)))
            }
        }
        return NetworkRequestImpl(request: request)
    }
    
    public func download(_ target: Target,
                         progressHandler: ProgressHandler? = nil,
                         completion: @escaping (Result<URL?, NetworkError>) -> Void) -> NetworkRequest {
        var request = session.buildDownloadRequest(target: target)
        if let progressHandler = progressHandler {
            request = request.uploadProgress(closure: progressHandler)
        }
        request.response { downloadResponse in
            switch downloadResponse.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let afError):
                if let statusCode = downloadResponse.response?.statusCode {
                    completion(.failure(NetworkError.statusCode(statusCode)))
                    return
                }
                completion(.failure(NetworkError.afError(afError)))
            }
        }
        return NetworkRequestImpl(request: request)
    }
    
    public func download(_ target: Target,
                         progressHandler: ProgressHandler? = nil,
                         completion: @escaping (Result<Data?, NetworkError>) -> Void) -> NetworkRequest {
        var request = session.buildDownloadRequest(target: target)
        if let progressHandler = progressHandler {
            request = request.uploadProgress(closure: progressHandler)
        }
        request.responseData { downloadResponse in
            switch downloadResponse.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let afError):
                if let statusCode = downloadResponse.response?.statusCode {
                    completion(.failure(NetworkError.statusCode(statusCode)))
                    return
                }
                completion(.failure(NetworkError.afError(afError)))
            }
        }
        return NetworkRequestImpl(request: request)
    }
}
