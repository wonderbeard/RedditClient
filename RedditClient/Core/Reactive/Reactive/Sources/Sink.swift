//
//  Sink.swift
//  Reactive
//
//  Created by Andrew Malyarchuk on 24.03.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

class Sink<Element>: Observer {
    
    private let handleElement: (Element) -> Void
    private var isDisposed = false
    
    init<O>(observer: O) where O: Observer, O.Element == Element {
        handleElement = observer.onNext
    }
    
    init(elementHandler: @escaping (Element) -> Void) {
        handleElement = elementHandler
    }
    
    func onNext(_ element: Element) {
        if !isDisposed {
            handleElement(element)
        }
    }
    
    func dispose() {
        isDisposed = true
    }
    
}

