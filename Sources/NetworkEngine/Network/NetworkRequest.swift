//
//  NetworkRequest.swift
//  
//
//  Created by Nishchal Visavadiya on 10/02/23.
//

import Foundation
import Alamofire

public protocol NetworkRequest: Cancellable { }

class NetworkRequestImpl: NetworkRequest {
    
    public var isCancelled: Bool = false
    
    var request: Request
    
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

extension Array<NetworkRequest> {
    
    public func cancel() {
        forEach { request in
            request.cancel()
        }
    }
}
