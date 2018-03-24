//
//  Observable+Closure.swift
//  Reactive
//
//  Created by Andrew Malyarchuk on 24.03.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

extension Observable {
    
    public func subscribe(_ handler: @escaping (Element) -> Void) -> Cancelable {
        return subscribe(AnyObserver(elementHandler: handler))
    }
    
}

