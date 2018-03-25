//
//  Observer.swift
//  Reactive
//
//  Created by Andrew Malyarchuk on 24.03.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

public protocol Observer {
    associatedtype Element
    func onNext(_ element: Element)
}

public class AnyObserver<Element>: Observer {
    
    private let handleElement: (Element) -> Void
    
    public init<O>(_ sourceObserver: O) where O: Observer, O.Element == Element {
        handleElement = sourceObserver.onNext
    }
    
    public init(elementHandler: @escaping (Element) -> Void) {
        handleElement = elementHandler
    }
    
    public func onNext(_ element: Element) {
        handleElement(element)
    }
    
}
