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
    
    private let performSubscribe: (AnyObserver<Element>) -> Cancelable
    private let handleElement: (Element) -> Void
    
    init<O1, O2>(observable: O1, observer: O2)
        where O1: Observable, O1.Element == Element, O2: Observer, O2.Element == Element
    {
        performSubscribe = observable.subscribe
        handleElement = observer.onNext
    }
    
    init<S>(_ source: S) where S: Subject, S.Element == Element {
        performSubscribe = source.subscribe
        handleElement = source.onNext
    }
    
    public func subscribe<O>(_ observer: O) -> Cancelable where O : Observer, E == O.Element {
        return performSubscribe(AnyObserver(observer))
    }
    
    public func onNext(_ element: E) {
        handleElement(element)
    }
    
}
