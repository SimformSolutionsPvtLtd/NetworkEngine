//
//  UploadTaskImplementation.swift
//  NetworkEngine
//
//  Created by Nishchal Visavadiya on 29/05/24.
//

import Alamofire
import Combine

/// Defines a UploadTask implementation
class UploadTaskImplementation: UploadTask {
    
    var response: HTTPURLResponse? {
        return request.response
    }
    
    private let request: DataRequest
    private var isCancelled = false
    
    init(request: DataRequest) {
        self.request = request
    }
    
    public func cancel() {
        if !isCancelled {
            request.cancel()
        }
        isCancelled = true
    }
    
    func upload(completion: @escaping (Result<Data?, NetworkError>) -> Void) {
        request.response { completion($0.mappedResult) }
    }
    
    func upload() -> AnyPublisher<Result<Data, NetworkError>, Never> {
        return request.publishData()
            .map { $0.mappedResult }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func upload() async -> Result<Data, NetworkError> {
        let response = await request.serializingData().response
        return response.mappedResult
    }
}
