//
//  PublishSubject.swift
//  Reactive
//
//  Created by Andrew Malyarchuk on 24.03.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

public class PublishSubject<E>: Subject {
    
    public typealias Element = E
    
    private var subscribers: [Sink<Element>] = []
    
    public init() {
    }
    
    public func subscribe<O: Observer>(_ observer: O) -> Cancelable where O.Element == Element {
        let sink = Sink(observer: observer)
        subscribers.append(sink)
        return ClosureCancelable {
            sink.dispose()
            // TODO: remove sink from subscribers
        }
    }
    
    public func onNext(_ element: Element) {
        subscribers.forEach{ $0.onNext(element) }
    }
    
}
