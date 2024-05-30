//
//  StringDataTask.swift
//  NetworkEngine
//
//  Created by Nishchal Visavadiya on 29/05/24.
//

import Alamofire
import Combine

/// Defines a StringRequestTask implementation
class StringRequestTaskImplementation: StringRequestTask {

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
    
    func request(completion: @escaping (Result<String, NetworkError>) -> Void) {
        dataRequest.responseString { completion($0.mappedResult) }
    }
    
    func request() -> AnyPublisher<Result<String, NetworkError>, Never> {
        return dataRequest
            .publishString()
            .map { $0.mappedResult }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func request() async -> Result<String, NetworkError> {
        let response = await dataRequest.serializingString().response
        return response.mappedResult
    }
}
