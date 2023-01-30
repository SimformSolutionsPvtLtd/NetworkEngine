//
//  NetworkProvider.swift
//
//
//  Created by Jatin Kathrotiya on 06/02/23.
//

import Foundation
import Alamofire

public struct NetworkProvider<Target: TargetType>: NetworkProviderType {

    public func request(
        _ target: TargetType,
        completion: @escaping (Result<Data?, AFError>) -> Void
    ) {
        AF.request(target).response { response in
            completion(response.result)
        }
    }

    public func request<T: Decodable>(
        _ target: TargetType,
        type: T.Type,
        completion: @escaping (Result<T, AFError>) -> Void
    ) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = target.keyDecodingStrategy
        AF.request(target).responseDecodable(decoder: decoder) { (response: DataResponse<T, AFError>) in
            completion(response.result)
        }
    }

    public func request(
        _ target: TargetType,
        completion: @escaping (Result<String, AFError>) -> Void
    ) {
        AF.request(target).responseString { response in
            completion(response.result)
        }
    }
}
