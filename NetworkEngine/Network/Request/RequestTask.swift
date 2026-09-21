//
//  RequestTask.swift
//  NetworkEngine
//
//  Created by Nishchal Visavadiya on 29/05/24.
//

import Foundation
import Combine

/// Defines a request task which could be used to perform cancellation and the request.
public protocol RequestTask {
    
    /// The response, only available once the result is ready
    var response: HTTPURLResponse? { get }
    
    /// Cancel the upload task
    func cancel()
}

/// A request task which could be used to get data in the form of `String`
public protocol StringRequestTask: RequestTask {
    
    ///  Use this request to get response in form of String
    /// - Parameters:
    ///   - completion:  A response of api in form off `Result<String, NetworkError>`
    func request(completion: @escaping (Result<String, NetworkError>) -> Void)
    
    ///  Use this request to get response in form of `String`
    /// - Parameters:
    /// - Returns: The `AnyPublisher` of type `Result<String, NetworkError>`
    func request() -> AnyPublisher<Result<String, NetworkError>, Never>
    
    ///  Use this request to get response in form of String
    /// - Parameters:
    /// - Returns: The response of api in form of `Result<String, NetworkError>`
    func request() async -> Result<String, NetworkError>
}

/// A request task which could be used to get data in the form of `Data`
public protocol DataRequestTask: RequestTask {
    
    ///  Use this request to get response in form of Data
    /// - Parameters:
    ///   - completion:  A response of api in form of `Result<Data?, NetworkError>`
    func request(completion: @escaping (Result<Data?, NetworkError>) -> Void)
    
    ///  Use this request to get response in form of `Data`
    /// - Parameters:
    /// - Returns: The `AnyPublisher` of type `Result<Data?, NetworkError>`
    func request() -> AnyPublisher<Result<Data?, NetworkError>, Never>
    
    ///  Use this request to get response in form of Data
    /// - Parameters:
    /// - Returns: The response of api in form of `Result<Data, NetworkError>`
    func request() async -> Result<Data, NetworkError>
}

/// A request task which could be used to get data in the form of `Decodable` type
public protocol DecodableRequestTask: RequestTask {
    
    /// Use this request to get response in form of Decodable
    /// - Parameters:
    ///    - type: The type to decode the response to
    ///    - completion: A response of api in form of Decodable or Error
    func request<T: Decodable>(type: T.Type,
                               completion: @escaping (Result<T, NetworkError>) -> Void)

    ///  Use this request to get response in form of `Decodable`
    /// - Parameters:
    ///   - type: A type confirming to `Decodable`
    /// - Returns: The `AnyPublisher` of type `Result<T, NetworkError>`
    func request<T: Decodable>(type: T.Type) -> AnyPublisher<Result<T, NetworkError>, Never>
    
    /// Use this request to get response in form of Decodable
    /// - Parameters:
    /// - Returns: The response of api in form of Decodable or Error
    func request<T: Decodable>(type: T.Type) async -> Result<T, NetworkError>
}
