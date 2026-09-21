//
//  DataRequestTaskImplementation.swift
//  NetworkEngine
//
//  Created by Nishchal Visavadiya on 30/05/24.
//

import Foundation
import Alamofire
import Combine

/// Defines a DataRequestTask implementation
class DataRequestTaskImplementation: DataRequestTask {
    
    var response: HTTPURLResponse? {
        return dataRequest.response
    }
    
    private let dataRequest: DataRequest
    private var isCancelled = false
    
    init(dataRequest: DataRequest) {
        self.dataRequest = dataRequest
    }
    
    func cancel() {
        if !isCancelled {
            dataRequest.cancel()
        }
        isCancelled = true
    }
    
    func request(completion: @escaping (Result<Data?, NetworkError>) -> Void) {
        dataRequest.response { completion($0.mappedResult) }
    }
    
    func request() -> AnyPublisher<Result<Data?, NetworkError>, Never> {
        return dataRequest
            .publishUnserialized()
            .map { $0.mappedResult }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func request() async -> Result<Data, NetworkError> {
        let response = await dataRequest.serializingData().response
        return response.mappedResult
    }
}
