//
//  Filter.swift
//  Reactive
//
//  Created by Andrew Malyarchuk on 24.03.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

extension Observable {
    
    public func filter(_ filter: @escaping (Element) -> Bool) -> AnyObservable<Element> {
        let filter = Filter(source: self, filter: filter)
        return AnyObservable(filter)
    }
    
}

final class Filter<E>: Observable {
    
    typealias Element = E
    
    private let source: AnyObservable<Element>
    private let filter: (Element) -> Bool
    
    init<O: Observable>(source: O, filter: @escaping (Element) -> Bool) where O.Element == Element {
        self.source = AnyObservable(source)
        self.filter = filter
    }
    
    func subscribe<O: Observer>(_ observer: O) where O.Element == Element {
        source.subscribe(FilterObserver(filter: filter, observer: observer))
    }
    
}

final class FilterObserver<Element>: Observer {
    
    private let filter: (Element) -> Bool
    private let observer: AnyObserver<Element>
    
    init<O: Observer>(filter: @escaping (Element) -> Bool, observer: O) where O.Element == Element {
        self.filter = filter
        self.observer = AnyObserver(observer)
    }
    
    func onNext(_ element: Element) {
        if filter(element) {
            observer.onNext(element)
        }
    }
    
}

