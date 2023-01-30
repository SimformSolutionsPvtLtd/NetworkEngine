//
//  TargetType.swift
//
//
//  Created by Jatin Kathrotiya on 06/02/23.
//

import Foundation
import Alamofire


/// Defines the target type for the networ call
public protocol TargetType: URLRequestConvertible {
    
    /// The target's base `URL`.
    var baseURL: URL { get }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }

    /// The HTTP method used in the request.
    var method: Method { get }
    
    /// The key decoding stratergy to use
    var keyDecodingStrategy: KeyDecodingStrategy { get }

    /// The headers to be used in the request.
    var headers: [String: String]? { get }
    
    /// The Network task to be performed.
    var task: NetworkTask { get }
}
