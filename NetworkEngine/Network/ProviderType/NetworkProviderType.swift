
import Foundation

/// Protocol defining the methods for various type of network calls on the `TargetType`
public protocol NetworkProviderType {
    
    associatedtype Target: TargetType

    ///  Use this request to get response in form of String
    /// - Parameters:
    ///   - target: A target API
    ///   - completion:  A response of api in form off `Result<String, NetworkError>`
    func request(_ target: Target,
                 completion: @escaping (Result<String, NetworkError>) -> Void)

    ///  Use this request to get response in form of Data
    /// - Parameters:
    ///   - target: A target API
    ///   - completion:  A response of api in form of `Result<Data?, NetworkError>`
    func request(_ target: Target,
                 completion: @escaping (Result<Data?, NetworkError>) -> Void)

    /// Use this request to get response in form of Decodable
    /// - Parameters:
    ///   - target: A target API
    ///   - completion: A response of api in form of Decodable or Error
    func request<T: Decodable>(_ target: Target,
                               type: T.Type,
                               completion: @escaping (Result<T, NetworkError>) -> Void)
    
    /// Use this method to upload the given target
    /// - Parameters:
    ///   - target: The `Target`
    ///   - progressHandler: The `ProgressHandler`
    ///   - completion: The completion handler
    func upload(_ target: Target,
                progressHandler: ProgressHandler?,
                completion: @escaping (Result<Data?, NetworkError>) -> Void)
    
    /// Use this method to build the download task
    /// generally use this method to download files
    /// - Parameters:
    ///   - target: The `Target`
    ///   - progressHandler: The `ProgressHandler`
    ///   - completion: The completion handler
    /// - Returns: The `DownloadTask`
    func download(_ target: Target,
                  progressHandler: ProgressHandler?) -> DownloadTask
}
