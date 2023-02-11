import Foundation

public protocol Cancellable {

    /// A Boolean value stating whether a request is cancelled.
    var isCancelled: Bool { get }

    /// Cancels the represented request.
    func cancel()
}
