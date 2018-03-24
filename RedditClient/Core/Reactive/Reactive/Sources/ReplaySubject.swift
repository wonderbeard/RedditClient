//
//  ReplaySubject.swift
//  Reactive
//
//  Created by Andrew Malyarchuk on 24.03.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

public class ReplaySubject<Element>: PublishSubject<Element> {
    
    private var replayBuffer: Buffer<Element>
    
    public init(replayBuffer: Buffer<Element>) {
        self.replayBuffer = replayBuffer
    }
    
    public convenience init(replay replayCount: Int = 0) {
        self.init(replayBuffer: Buffer(size: replayCount))
    }
    
    public override func subscribe<O: Observer>(_ observer: O) -> Cancelable where O.Element == Element {
        replayBuffer.forEach(observer.onNext)
        return super.subscribe(observer)
    }
    
    public override func onNext(_ element: Element) {
        replayBuffer.insert(element)
        super.onNext(element)
    }
    
}

