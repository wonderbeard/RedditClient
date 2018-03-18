//
//  Observable.swift
//  RedditClient
//
//  Created by Andrew Malyarchuk on 18.03.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

import Foundation

public class Observable<Element> {
    
    private(set) var subscribers: [(Element) -> Void] = []
    
    public func subscribe(_ subscriber: @escaping (Element) -> Void) {
        subscribers.append(subscriber)
    }
    
}
