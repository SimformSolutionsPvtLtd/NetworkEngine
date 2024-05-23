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
        let response = await session.buildRequest(target: target).validate().serializingString().response
        return response.mappedResult
    }
    
    public func request(_ target: Target) async -> Result<Data, NetworkError> {
        let response = await session.buildRequest(target: target).validate().serializingData().response
        return response.mappedResult
    }
    
    public func request<T: Decodable>(_ target: Target,
                                      type: T.Type) async -> Result<T, NetworkError> {
        let response = await session.buildRequest(target: target).validate().serializingDecodable(type).response
        return response.mappedResult
    }
    
    public func upload(_ target: Target,
                       progressHandler: ProgressHandler?) async -> Result<Data, NetworkError> {
        var request = session.buildRequest(target: target).validate()
        if let progressHandler = progressHandler {
            request = request.uploadProgress(closure: progressHandler)
        }
        let response = await request.serializingData().response
        return response.mappedResult
    }
    
    public func download(_ target: Target,
                         progressHandler: ProgressHandler?) async -> Result<URL, NetworkError> {
        var request = session.buildDownloadRequest(target: target).validate()
        if let progressHandler = progressHandler {
            request = request.downloadProgress(closure: progressHandler)
        }
        let response = await request.serializingDownloadedFileURL().response
        return response.mappedResult
    }
    
    public func download(_ target: Target,
                         progressHandler: ProgressHandler?) async -> Result<Data, NetworkError> {
        var request = session.buildDownloadRequest(target: target).validate()
        if let progressHandler = progressHandler {
            request = request.downloadProgress(closure: progressHandler)
        }
        let response = await request.serializingData().response
        return response.mappedResult
    }
}
