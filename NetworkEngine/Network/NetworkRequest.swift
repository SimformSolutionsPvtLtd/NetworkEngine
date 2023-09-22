import Foundation
import Alamofire

/// The NetworkRequest confirming to `Cncellable`
public protocol NetworkRequest: Cancellable { }

/// Implementation of `NetworkRequest`
class NetworkRequestImpl: NetworkRequest {
    
    private (set) var isCancelled: Bool = false
    private (set) var request: Request
    
    init(request: Request) {
        self.request = request
    }
    
    public func cancel() {
        if !request.isCancelled || !request.isFinished {
            request.cancel()
        }
        isCancelled = true
    }
}

// MARK: Extension on NetworkRequest array
extension Array<NetworkRequest> {
    
    /// Cancels all the request in current array (if not alreayd finished or cancelled)
    public func cancel() {
        forEach { request in
            request.cancel()
        }
    }
}
