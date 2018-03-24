//
//  Observer+Void.swift
//  Reactive
//
//  Created by Andrew Malyarchuk on 24.03.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

extension Observer where Element == Void {
    
    public func onNext() {
        onNext(())
    }
    
}
