//
//  DecodableRequestTaskImplementation.swift
//  NetworkEngine
//
//  Created by Nishchal Visavadiya on 30/05/24.
//

import Alamofire
import Combine

/// Defines a DecodableRequestTask implementation
class DecodableRequestTaskImplementation: DecodableRequestTask {
    
    var response: HTTPURLResponse? {
        return dataRequest.response
    }
    
    private let dataRequest: DataRequest
    private let decoder: JSONDecoder
    private var isCancelled = false
    
    init(dataRequest: DataRequest, decoder: JSONDecoder) {
        self.dataRequest = dataRequest
        self.decoder = decoder
    }
    
    func cancel() {
        if !isCancelled {
            dataRequest.cancel()
        }
        isCancelled = true
    }
    
    func request<T>(type: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) where T : Decodable {
        dataRequest.responseDecodable(decoder: decoder) { completion($0.mappedResult) }
    }
    
    func request<T>(type: T.Type) -> AnyPublisher<Result<T, NetworkError>, Never> where T : Decodable {
        return dataRequest
            .publishDecodable(type: T.self, decoder: decoder)
            .map { $0.mappedResult }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func request<T>(type: T.Type) async -> Result<T, NetworkError> where T : Decodable {
        let response = await dataRequest.serializingDecodable(type, decoder: decoder).response
        return response.mappedResult
    }
}
