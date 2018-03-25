//
//  Cancelable.swift
//  Reactive
//
//  Created by Andrew Malyarchuk on 24.03.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

public protocol Cancelable {
    func cancel()
}

public class ClosureCancelable: Cancelable {
    
    private let performCancel: () -> Void
    
    public init(action: @escaping () -> Void) {
        self.performCancel = action
    }
    
    public func cancel() {
        performCancel()
    }
    
}

public class NotCancellable: Cancelable {
    
    public init() {
    }
    
    public func cancel() {
    }
    
}

public class CompositeCancelable: Cancelable {
    
    private let cancellables: [Cancelable]
    
    public init(_ composables: Cancelable...) {
        self.cancellables = composables
    }
    
    public func cancel() {
        cancellables.forEach{ $0.cancel() }
    }
    
}
