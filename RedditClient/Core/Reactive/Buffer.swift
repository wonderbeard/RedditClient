//
//  Buffer.swift
//  RedditClient
//
//  Created by Andrew Malyarchuk on 18.03.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

import Foundation

struct Buffer<Element>: Sequence {
    
    private let size: Int
    private var contents: [Element] = []
    
    init(size: Int) {
        self.size = size
    }
    
    func makeIterator() -> AnyIterator<Element> {
        var iterator = contents.makeIterator()
        return AnyIterator{ iterator.next() }
    }
    
    mutating func enqueue(_ element: Element) {
        contents.append(element)
        if contents.count > size {
            contents.removeFirst()
        }
    }
    
}
