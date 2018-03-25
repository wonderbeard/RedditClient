//
//  ImageLoader+Reactive.swift
//  RedditClient
//
//  Created by Andrew Malyarchuk on 25.03.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

import Reactive

extension ImageLoader {
    
    public func loadImage(url: URL) -> Action<UIImage> {
        return Action { observer in
            self.loadImage(url: url, success: observer.onNext)
            return NotCancellable()
        }
    }
    
}
