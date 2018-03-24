//
//  Buffer.swift
//  Reactive
//
//  Created by Andrew Malyarchuk on 24.03.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

public struct Buffer<Element>: Sequence {
    
    private let size: Int
    private var contents: [Element] = []
    
    public init(size: Int) {
        self.size = size
    }
    
    public func makeIterator() -> AnyIterator<Element> {
        var iterator = contents.makeIterator()
        return AnyIterator{ iterator.next() }
    }
    
    public mutating func insert(_ element: Element) {
        contents.append(element)
        if contents.count > size {
            contents.removeFirst()
        }
    }
    
}

