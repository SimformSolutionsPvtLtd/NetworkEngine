//
//  NetworkProviderAsyncAwait.swift
//  NetworkEngine
//
//  Created by Nishchal Visavadiya on 24/05/24.
//

import Foundation

/// This extension provide async await support to `NetworkProvider`
extension NetworkProvider: NetworkProviderTypeAsyncAwait {
    
    public func request(_ target: Target) async -> Result<String, NetworkError> {
        return await requestString(target).request()
    }
    
    public func request(_ target: Target) async -> Result<Data, NetworkError> {
        return await requestData(target).request()
    }
    
    public func request<T: Decodable>(_ target: Target,
                                      type: T.Type) async -> Result<T, NetworkError> {
        return await requestDecodable(target).request(type: type)
    }
    
    public func upload(_ target: Target,
                       progressHandler: ProgressHandler?) async -> Result<Data, NetworkError> {
        return await upload(target, progressHandler: progressHandler).upload()
    }
}
