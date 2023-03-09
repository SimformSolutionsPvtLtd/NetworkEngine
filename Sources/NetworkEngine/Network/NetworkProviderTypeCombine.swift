import Foundation
import Combine

@available(macOS 10.15, *)
@available(iOS 13.0, *)
/// Protocol defining the combine supported methods for various tyoe of network calls on the `TargetType`
public protocol NetworkProviderTypeCombine {
    
    associatedtype Target: TargetType

    ///  Use this request to get response in form of String
    /// - Parameters:
    ///   - target: A target API
    /// - Returns: The `AnyPublisher` of type `Result<String, NetworkError>`
    func request(_ target: Target) -> AnyPublisher<Result<String, NetworkError>, Never>

    ///  Use this request to get response in form of Data
    /// - Parameters:
    ///   - target: A target API
    /// - Returns: The `AnyPublisher` of type `Result<Data?, NetworkError>`
    func request(_ target: Target) -> AnyPublisher<Result<Data?, NetworkError>, Never>

    ///  Use this request to get response in form of Decodable
    /// - Parameters:
    ///   - target: A target API
    ///   - type: A type confirming to `Decodable`
    /// - Returns: The `AnyPublisher` of type `Result<T, NetworkError>`
    func request<T: Decodable>(_ target: Target,
                               type: T.Type) -> AnyPublisher<Result<T, NetworkError>, Never>
}
