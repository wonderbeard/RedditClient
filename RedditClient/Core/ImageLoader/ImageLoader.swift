//
//  ImageLoader.swift
//  RedditClient
//
//  Created by Andrew Malyarchuk on 25.03.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

import UIKit

public enum ImageLoadError: Error {
    case retrieval(Error?)
    case serialization
    case unknown(Error)
}

public protocol ImageLoader {
    
    func loadImage(
        url: URL,
        success: @escaping (UIImage) -> Void,
        failure: ((ImageLoadError) -> Void)?
    )
    
}

extension ImageLoader {
    
    public func loadImage(
        url: URL,
        success resolve: @escaping (UIImage) -> Void)
    {
        loadImage(url: url, success: resolve, failure: nil)
    }
    
}
