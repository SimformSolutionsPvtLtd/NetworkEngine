//
//  NetworkProviderType.swift
//
//
//  Created by Jatin Kathrotiya on 06/02/23.
//

import Foundation
import Alamofire
import Combine

public protocol NetworkProviderType {

    ///  Use this request to ge response in form of Data
    /// - Parameters:
    ///   - target: A target Api
    ///   - completion:  A response of api in of Data or Error
    func request(
        _ target: TargetType,
        completion: @escaping (Result<String, AFError>) -> Void
    )

    ///  Use this request to ge response in form of Data
    /// - Parameters:
    ///   - target: A target Api
    ///   - completion:  A response of api in of Data or Error
    func request(
        _ target: TargetType,
        completion: @escaping (Result<Data?, AFError>) -> Void
    )

    /// Use this request to get response in form of Decodable
    /// - Parameters:
    ///   - target: A target Api
    ///   - completion: A response of api in form of Decodable or Error
    func request<T: Decodable>(
        _ target: TargetType,
        type: T.Type,
        completion: @escaping (Result<T, AFError>) -> Void
    )
}
