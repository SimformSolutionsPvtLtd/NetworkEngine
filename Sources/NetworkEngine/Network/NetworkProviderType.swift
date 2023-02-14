import Foundation
import Alamofire
import Combine

public protocol NetworkProviderType {
    
    associatedtype Target: TargetType

    ///  Use this request to ge response in form of Data
    /// - Parameters:
    ///   - target: A target Api
    ///   - completion:  A response of api in of Data or Error
    func request(_ target: Target,
                 completion: @escaping (Result<String, NetworkError>) -> Void) -> NetworkRequest

    ///  Use this request to ge response in form of Data
    /// - Parameters:
    ///   - target: A target Api
    ///   - completion:  A response of api in of Data or Error
    func request(_ target: Target,
                 completion: @escaping (Result<Data?, NetworkError>) -> Void) -> NetworkRequest

    /// Use this request to get response in form of Decodable
    /// - Parameters:
    ///   - target: A target Api
    ///   - completion: A response of api in form of Decodable or Error
    func request<T: Decodable>(_ target: Target,
                               type: T.Type,
                               completion: @escaping (Result<T, NetworkError>) -> Void) -> NetworkRequest
    
    @available(macOS 10.15, *)
    @available(iOS 13.0, *)
    func request(_ target: Target) -> AnyPublisher<Result<String, NetworkError>, Never>
    
    @available(macOS 10.15, *)
    @available(iOS 13.0, *)
    func request(_ target: Target) -> AnyPublisher<Result<Data?, NetworkError>, Never>
    
    @available(macOS 10.15, *)
    @available(iOS 13.0, *)
    func request<T: Decodable>(_ target: Target,
                               type: T.Type) -> AnyPublisher<Result<T, NetworkError>, Never>
}
