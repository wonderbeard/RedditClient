//
//  Observable.swift
//  Reactive
//
//  Created by Andrew Malyarchuk on 24.03.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

public protocol Observable {
    associatedtype Element
    func subscribe<O: Observer>(_ observer: O) -> Cancelable where O.Element == Element
}

public class AnyObservable<E>: Observable {
    
    public typealias Element = E
    
    private let performSubscription: (AnyObserver<Element>) -> Cancelable
    
    public init<O: Observable>(_ source: O) where O.Element == Element {
        performSubscription = { source.subscribe($0) }
    }
    
    public func subscribe<O: Observer>(_ observer: O) -> Cancelable where O.Element == Element {
        return performSubscription(AnyObserver(observer))
    }
    
}

