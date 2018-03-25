//
//  ImageLoaderWithCache.swift
//  RedditClient
//
//  Created by Andrew Malyarchuk on 25.03.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

import UIKit

public struct ImageLoaderWithCache: ImageLoader {
    
    private let sourceLoader: ImageLoader
    private let cache: NSCache<NSString, UIImage>
    
    public init(
        source: ImageLoader,
        cache: NSCache<NSString, UIImage> = {
            let cache = NSCache<NSString, UIImage>()
            cache.countLimit = 20
            return cache
        }())
    {
        self.sourceLoader = source
        self.cache = cache
    }
    
    public func loadImage(
        url: URL,
        success resolve: @escaping (UIImage) -> Void,
        failure reject: ((ImageLoadError) -> Void)?)
    {
        if let cachedImage = cache.object(forKey: url.absoluteString as NSString) {
            resolve(cachedImage)
        }
        else {
            sourceLoader.loadImage(
                url: url,
                success: { [cache] image in
                    resolve(image)
                    cache.setObject(image, forKey: url.absoluteString as NSString)
                },
                failure: reject
            )
        }
    }
    
}

