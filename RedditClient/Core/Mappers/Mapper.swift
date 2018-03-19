//
//  Mapper.swift
//  RedditClient
//
//  Created by Andrew Malyarchuk on 19.03.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

import Foundation

protocol Mapper {
    associatedtype Value
    associatedtype Result
    func map(_ value: Value) -> Result
}

struct AnyMapper<Value, Result>: Mapper {
    
    private let performMap: (Value) -> Result
    
    init(_ mapping: @escaping (Value) -> Result) {
        performMap = mapping
    }
    
    init<M: Mapper>(_ sourceMapper: M) where M.Value == Value, M.Result == Result {
        performMap = sourceMapper.map
    }
    
    func map(_ value: Value) -> Result {
        return performMap(value)
    }
    
}
