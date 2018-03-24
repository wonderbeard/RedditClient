//
//  Action.swift
//  Reactive
//
//  Created by Andrew Malyarchuk on 24.03.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

public class Action<Result>: Observable {
    
    public typealias Element = Result
    
    private let performSubscribe: (AnyObserver<Element>) -> Cancelable
    
    public init(_ main: @escaping (AnyObserver<Element>) -> Cancelable) {
        performSubscribe = main
    }
    
    public func subscribe<O: Observer>(_ observer: O) -> Cancelable where O.Element == Result {
        let subscription = performSubscribe(AnyObserver(observer))
        return ClosureCancelable {
            // TODO: check if necessary to capture/release self
            _ = self
            subscription.cancel()
        }
    }
    
}
