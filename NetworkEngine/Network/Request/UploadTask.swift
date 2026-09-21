//
//  UploadTask.swift
//  NetworkEngine
//
//  Created by Nishchal Visavadiya on 29/05/24.
//

import Foundation
import Combine

/// Defines a upload task which could be used to perform cancellation and the upload.
public protocol UploadTask: RequestTask {
    
    /// Use this method to upload the given target
    /// - Parameters:
    ///   - completion: The completion handler
    func upload(completion: @escaping (Result<Data?, NetworkError>) -> Void)
    
    /// Use this method to upload the given target data
    /// - Parameters:
    /// - Returns: The `AnyPublisher` of type `Result<Data, NetworkError>`
    func upload() -> AnyPublisher<Result<Data, NetworkError>, Never>
    
    /// Use this method to upload the given target
    /// - Parameters:
    /// - Returns: The result of type `Result<Data, NetworkError>`
    func upload() async -> Result<Data, NetworkError>
}
