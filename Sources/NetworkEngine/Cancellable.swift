//
//  Cancellable.swift
//
//
//  Created by Jatin Kathrotiya on 06/02/23.
//

import Foundation

protocol Cancellable {

    /// A Boolean value stating whether a request is cancelled.
    var isCancelled: Bool { get }

    /// Cancels the represented request.
    func cancel()
}
