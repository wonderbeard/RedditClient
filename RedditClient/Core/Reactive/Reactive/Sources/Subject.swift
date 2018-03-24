//
//  Subject.swift
//  Reactive
//
//  Created by Andrew Malyarchuk on 24.03.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

public typealias Subject = Observable & Observer

public struct AnySubject<E>: Subject {
    
    public typealias Element = E
    
    private let observable: AnyObservable<Element>
    private let observer: AnyObserver<Element>
    
    init<O1, O2>(observable: O1, observer: O2)
        where O1: Observable, O1.Element == Element, O2: Observer, O2.Element == Element
    {
        self.observable = AnyObservable(observable)
        self.observer = AnyObserver(observer)
    }
    
    public func subscribe<O>(_ observer: O) where O : Observer, E == O.Element {
        observable.subscribe(observer)
    }
    
    public func onNext(_ element: E) {
        observer.onNext(element)
    }
    
}
