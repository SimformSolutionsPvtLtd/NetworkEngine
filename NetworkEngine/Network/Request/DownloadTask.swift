//
//  File.swift
//  NetworkEngine
//
//  Created by Nishchal Visavadiya on 29/05/24.
//

import Foundation
import Combine

/// Defines a download task which could be used to perform cancellation and the download.
public protocol DownloadTask {
    
    /// Cancel the task
    /// - Parameter callback: The callback producing the resume `Data`
    func cancel(_ callback: @escaping (Data?) -> Void)
    
    /// Cancel the task producing the data
    /// - Returns: The resume `Data`
    func cancelProducingData() async -> Data?
    
    /// Use this method to download the given task and get the response in the form of `URL`
    /// - Parameters:
    ///   - completion: The completion handler
    func download(completion: @escaping (Result<URL?, NetworkError>) -> Void)
    
    /// Use this method to download the given task and get the response in the form of `Data`
    /// - Parameters:
    ///   - completion: The completion handler
    func download(completion: @escaping (Result<Data, NetworkError>) -> Void)
    
    /// Use this method to download the given task data
    /// - Returns: The `AnyPublisher` of type `Result<URL, NetworkError>`
    func download() -> AnyPublisher<Result<URL, NetworkError>, Never>
    
    /// Use this method to download the given task data
    /// - Returns: The `AnyPublisher` of type `Result<Data, NetworkError>`
    func download() -> AnyPublisher<Result<Data, NetworkError>, Never>
    
    /// Use this method to download the given target task and get response in the form URL of resource
    /// - Returns: The result of type `Result<URL, NetworkError>`
    func download() async -> Result<URL, NetworkError>
    
    /// Use this method to download the given task and get the response in the form of `Data`
    /// - Returns: The result of type `Result<Data, NetworkError>`
    func download() async -> Result<Data, NetworkError>
}
