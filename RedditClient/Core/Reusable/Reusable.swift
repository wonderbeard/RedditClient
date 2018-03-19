//
//  Reusable.swift
//  RedditClient
//
//  Created by Andrew Malyarchuk on 19.03.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

import Foundation

public struct Reusable<Object> {
    
    public var reuseIdentifier: String
    
    public init(_ reuseIdentifier: String) {
        self.reuseIdentifier = reuseIdentifier
    }
    
}

extension Reusable: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: String) {
        self.reuseIdentifier = value
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        self.reuseIdentifier = value
    }
    
    public init(unicodeScalarLiteral value: String) {
        self.reuseIdentifier = value
    }
    
}
