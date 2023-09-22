import Foundation


/// Cancellable protocoal whihc can be used to make the `NetworkRequest` cancellable
public protocol Cancellable {

    /// A Boolean value stating whether this cancellanle is cancelled or not
    var isCancelled: Bool { get }

    /// Cancel this cancellanle
    func cancel()
}
