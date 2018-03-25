//
//  Action.swift
//  Reactive
//
//  Created by Andrew Malyarchuk on 24.03.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

public class Action<Result>: Observable {
    
    public typealias Element = Result
    
    private let run: (Sink<Element>) -> Cancelable
    
    public init(_ main: @escaping (AnyObserver<Element>) -> Cancelable) {
        run = { main(AnyObserver($0)) }
    }
    
    public func subscribe<O: Observer>(_ observer: O) -> Cancelable where O.Element == Result {
        let sink = Sink(observer: observer)
        let actionSubscription = run(sink)
        return ClosureCancelable {
            sink.dispose()
            actionSubscription.cancel()
        }
    }
    
}
