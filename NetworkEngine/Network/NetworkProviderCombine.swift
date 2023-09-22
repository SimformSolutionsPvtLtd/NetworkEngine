
import Foundation
import Combine

// MARK: Combine methods
@available(macOS 10.15, *)
@available(iOS 13.0, *)
extension NetworkProvider: NetworkProviderTypeCombine {

    public func request(_ target: Target) -> AnyPublisher<Result<String, NetworkError>, Never> {
        return session.buildRequest(target: target)
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

    public func request(_ target: Target) -> AnyPublisher<Result<Data?, NetworkError>, Never> {
        return session.buildRequest(target: target)
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

    public func request<T: Decodable>(_ target: Target,
                                      type: T.Type) -> AnyPublisher<Result<T, NetworkError>, Never> {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = target.keyDecodingStrategy
        return session.buildRequest(target: target)
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
    
    public func upload(_ target: Target,
                       progressHandler: ProgressHandler?) -> AnyPublisher<Result<Data, NetworkError>, Never> {
        var request = session.buildRequest(target: target)
        if let progressHandler = progressHandler {
            request = request.uploadProgress(closure: progressHandler)
        }
        return request.publishData().map { uploadResponse in
            let newResult: Result<Data, NetworkError>
            switch uploadResponse.result {
            case .success(let data):
                newResult = .success(data)
            case .failure(let afError):
                if let statusCode = uploadResponse.response?.statusCode {
                    newResult = .failure(NetworkError.statusCode(statusCode))
                    break
                }
                newResult = .failure(NetworkError.afError(afError))
            }
            return newResult
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    public func download(_ target: Target,
                         progressHandler: ProgressHandler?) -> AnyPublisher<Result<URL, NetworkError>, Never> {
        var request = session.buildDownloadRequest(target: target)
        if let progressHandler = progressHandler {
            request = request.uploadProgress(closure: progressHandler)
        }
        return request.publishURL().map { uploadResponse in
            let newResult: Result<URL, NetworkError>
            switch uploadResponse.result {
            case .success(let data):
                newResult = .success(data)
            case .failure(let afError):
                if let statusCode = uploadResponse.response?.statusCode {
                    newResult = .failure(NetworkError.statusCode(statusCode))
                    break
                }
                newResult = .failure(NetworkError.afError(afError))
            }
            return newResult
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    public func download(_ target: Target,
                         progressHandler: ProgressHandler?) -> AnyPublisher<Result<Data, NetworkError>, Never> {
        var request = session.buildDownloadRequest(target: target)
        if let progressHandler = progressHandler {
            request = request.uploadProgress(closure: progressHandler)
        }
        return request.publishData().map { uploadResponse in
            let newResult: Result<Data, NetworkError>
            switch uploadResponse.result {
            case .success(let data):
                newResult = .success(data)
            case .failure(let afError):
                if let statusCode = uploadResponse.response?.statusCode {
                    newResult = .failure(NetworkError.statusCode(statusCode))
                    break
                }
                newResult = .failure(NetworkError.afError(afError))
            }
            return newResult
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
