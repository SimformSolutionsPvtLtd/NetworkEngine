
import Foundation
import Alamofire

public typealias ProgressHandler = (Progress) -> Void

/// Alamofire
public typealias Method = Alamofire.HTTPMethod
public typealias ParameterEncoding = Alamofire.ParameterEncoding
public typealias RequestMultipartFormData = Alamofire.MultipartFormData
public typealias DownloadDestination = Alamofire.DownloadRequest.Destination
public typealias URLEncoding = Alamofire.URLEncoding

/// JSON
public typealias KeyDecodingStrategy = JSONDecoder.KeyDecodingStrategy
