//
//  ImageViewerModel.swift
//  RedditClient
//
//  Created by Andrew Malyarchuk on 08.04.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

import UIKit

enum ImageViewerError {
    case failedToLoadImage
    case unknown(Error?)
}

class ImageViewerModel {
    
    let imageURL: URL
    let imageLoader: ImageLoader
    
    init(imageURL: URL, imageLoader: ImageLoader = DefaultImageLoader()) {
        self.imageURL = imageURL
        self.imageLoader = imageLoader
    }
    
    func loadImage(
        success resolve: @escaping (UIImage) -> Void,
        failure reject: @escaping (ImageViewerError) -> Void)
    {
        imageLoader.loadImage(
            url: imageURL,
            success: resolve,
            failure: { _ in
                reject(.failedToLoadImage)
            }
        )
    }
    
}
