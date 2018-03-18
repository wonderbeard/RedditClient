//
//  Subject.swift
//  RedditClient
//
//  Created by Andrew Malyarchuk on 18.03.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

import Foundation

public final class Subject<Element>: Observable<Element> {
    
    private var replayBuffer: Buffer<Element>
    
    public init(replay replayCount: Int = 0) {
        replayBuffer = Buffer(size: replayCount)
    }
    
    public func onNext(_ element: Element) {
        subscribers.forEach{ $0(element) }
        replayBuffer.enqueue(element)
    }
    
    public override func subscribe(_ observer: @escaping (Element) -> Void) {
        super.subscribe(observer)
        replayBuffer.forEach(observer)
    }
    
}

extension Subject where Element == Void {
    
    public func onNext() {
        onNext(())
    }
    
}
