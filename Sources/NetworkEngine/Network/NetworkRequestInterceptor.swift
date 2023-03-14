import Foundation
import Alamofire

/// A network request interceptor with adapt and retry methods
/// - adapt: Configure the HTTP request before the call
/// - retry: Define the retry policy
public protocol NetworkRequestInterceptor: RequestInterceptor {
}
