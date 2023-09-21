
import Foundation

/// Cancellable protocol which can be used to make the `NetworkRequest` cancellable
public protocol Cancellable {

    /// A Boolean value stating whether this cancellable is cancelled or not
    var isCancelled: Bool { get }

    /// Cancel this cancellable
    func cancel()
}
