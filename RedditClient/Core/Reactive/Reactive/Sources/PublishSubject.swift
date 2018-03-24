//
//  PublishSubject.swift
//  Reactive
//
//  Created by Andrew Malyarchuk on 24.03.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

public class PublishSubject<E>: Subject {
    
    public typealias Element = E
    
    private var observers: [AnyObserver<Element>] = []
    
    public func subscribe<O: Observer>(_ observer: O) where O.Element == Element {
        observers.append(AnyObserver(observer))
    }
    
    public func onNext(_ element: Element) {
        observers.forEach{ $0.onNext(element) }
    }
    
}
