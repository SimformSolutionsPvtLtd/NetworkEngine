
import Foundation

/// Protocol defining the methods for various type of network calls on the `TargetType`
public protocol NetworkProviderType {
    
    associatedtype Target: TargetType

    ///  Use this request to get response in form of String
    /// - Parameters:
    ///   - target: A target API
    ///   - completion:  A response of api in of Data or Error
    /// - Returns: The `NetworkRequest`
    func request(_ target: Target,
                 completion: @escaping (Result<String, NetworkError>) -> Void) -> NetworkRequest

    ///  Use this request to get response in form of Data
    /// - Parameters:
    ///   - target: A target API
    ///   - completion:  A response of api in of Data or Error
    /// - Returns: The `NetworkRequest`
    func request(_ target: Target,
                 completion: @escaping (Result<Data?, NetworkError>) -> Void) -> NetworkRequest

    /// Use this request to get response in form of Decodable
    /// - Parameters:
    ///   - target: A target API
    ///   - completion: A response of api in form of Decodable or Error
    /// - Returns: The `NetworkRequest`
    func request<T: Decodable>(_ target: Target,
                               type: T.Type,
                               completion: @escaping (Result<T, NetworkError>) -> Void) -> NetworkRequest
    
    /// Use this method to upload the given target
    /// - Parameters:
    ///   - target: The `Target`
    ///   - progressHandler: The `ProgressHandler`
    ///   - completion: The completion handler
    /// - Returns: The `NetworkRequest`
    func upload(_ target: Target,
                progressHandler: ProgressHandler?,
                completion: @escaping (Result<Data?, NetworkError>) -> Void) -> NetworkRequest
    
    /// Use this method to download the given target and get the response in the form of `URL`
    /// generally use this method to downlod files
    /// - Parameters:
    ///   - target: The `Target`
    ///   - progressHandler: The `ProgressHandler`
    ///   - completion: The completion handler
    /// - Returns: The `NetworkRequest`
    func download(_ target: Target,
                  progressHandler: ProgressHandler?,
                  completion: @escaping (Result<URL?, NetworkError>) -> Void) -> NetworkRequest
    
    /// Use this method to download the given target and get the response in the form of `Data`
    /// - Parameters:
    ///   - target: The `Target`
    ///   - progressHandler: The `ProgressHandler`
    ///   - completion: The completion handler
    /// - Returns: The `NetworkRequest`
    func download(_ target: Target,
                         progressHandler: ProgressHandler?,
                         completion: @escaping (Result<Data?, NetworkError>) -> Void) -> NetworkRequest
}
