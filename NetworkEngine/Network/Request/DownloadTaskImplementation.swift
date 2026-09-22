//
//  DownloadRequest.swift
//  NetworkEngine
//
//  Created by Nishchal Visavadiya on 28/05/24.
//

import Foundation
import Alamofire
import Combine

/// Defines a DownloadTask implementation
public class DownloadTaskImplementation: DownloadTask {
    
    private let request: DownloadRequest
    
    init(request: DownloadRequest) {
        self.request = request
    }

    public func cancel(_ callback: @escaping (Data?) -> Void) {
        request.cancel { data in
            callback(data)
        }
    }
    
    public func cancelProducingData() async -> Data? {
        return await withCheckedContinuation { continuation in
            request.cancel { data in
                continuation.resume(returning: data)
            }
        }
    }
}

extension DownloadTaskImplementation {
    
    public func download(completion: @escaping (Result<URL?, NetworkError>) -> Void) {
        request.response { completion($0.mappedResult) }
    }
    
    public func download(completion: @escaping (Result<Data, NetworkError>) -> Void) {
        request.responseData { completion($0.mappedResult) }
    }
}

extension DownloadTaskImplementation {
    
    public func download() -> AnyPublisher<Result<URL, NetworkError>, Never> {
        return request.publishURL()
            .map { $0.mappedResult }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    public func download() -> AnyPublisher<Result<Data, NetworkError>, Never> {
        return request.publishData()
            .map { $0.mappedResult }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

extension DownloadTaskImplementation {
    
    public func download() async -> Result<URL, NetworkError> {
        let response = await request.serializingDownloadedFileURL().response
        return response.mappedResult
    }
    
    public func download() async -> Result<Data, NetworkError> {
        let response = await request.serializingData().response
        return response.mappedResult
    }
}
