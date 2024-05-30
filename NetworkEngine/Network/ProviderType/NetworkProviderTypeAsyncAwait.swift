//
//  NetworkProviderTypeAsyncAwait.swift
//  NetworkEngine
//
//  Created by Nishchal Visavadiya on 24/05/24.
//

import Foundation

/// Protocol defining the async await support methods for various type of network calls on the `TargetType`
public protocol NetworkProviderTypeAsyncAwait {
    
    associatedtype Target: TargetType
    
    ///  Use this request to get response in form of String
    /// - Parameters:
    ///   - target: A target API
    /// - Returns: The response of api in form of `Result<String, NetworkError>`
    func request(_ target: Target) async -> Result<String, NetworkError>
    
    ///  Use this request to get response in form of Data
    /// - Parameters:
    ///   - target: A target API
    /// - Returns: The response of api in form of `Result<Data, NetworkError>`
    func request(_ target: Target) async -> Result<Data, NetworkError>
    
    /// Use this request to get response in form of Decodable
    /// - Parameters:
    ///   - target: A target API
    /// - Returns: The response of api in form of Decodable or Error
    func request<T: Decodable>(_ target: Target,
                               type: T.Type) async -> Result<T, NetworkError>
    
    /// Use this method to upload the given target
    /// - Parameters:
    ///   - target: The `Target`
    ///   - progressHandler: The `ProgressHandler`
    /// - Returns: The result of type `Result<Data, NetworkError>`
    func upload(_ target: Target,
                progressHandler: ProgressHandler?) async -> Result<Data, NetworkError>
}
