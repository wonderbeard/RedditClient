//
//  Map.swift
//  Reactive
//
//  Created by Andrew Malyarchuk on 24.03.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

extension Observable {
    
    public func map<T>(_ mapping: @escaping (Element) -> T) -> AnyObservable<T> {
        let map = Map(source: self, transform: mapping)
        return AnyObservable(map)
    }
    
}

final class Map<Source, Result>: Observable {
    
    typealias Element = Result
    
    private let source: AnyObservable<Source>
    private let transform: (Source) -> Result
    
    init<O: Observable>(source: O, transform: @escaping (Source) -> Result) where O.Element == Source {
        self.source = AnyObservable(source)
        self.transform = transform
    }
    
    func subscribe<O: Observer>(_ observer: O) -> Cancelable where O.Element == Result {
        let mapObserver = MapObserver(transform: transform, observer: observer)
        return source.subscribe(mapObserver)
    }
    
}

final class MapObserver<Source, Result>: Observer {
    
    private let transform: (Source) -> Result
    private let observer: AnyObserver<Result>
    
    init<O: Observer>(transform: @escaping (Source) -> Result, observer: O) where O.Element == Result {
        self.transform = transform
        self.observer = AnyObserver(observer)
    }
    
    func onNext(_ element: Source) {
        let mappedElement = transform(element)
        observer.onNext(mappedElement)
    }
    
}
