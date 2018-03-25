//
//  DefaultImageLoader.swift
//  RedditClient
//
//  Created by Andrew Malyarchuk on 25.03.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

import UIKit

public class DefaultImageLoader: ImageLoader {
    
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func loadImage(
        url: URL,
        success resolve: @escaping (UIImage) -> Void,
        failure reject: ((ImageLoadError) -> Void)?)
    {
        session.dataTask(with: url) { (data, _, error) in
            
            guard let imageData = data else {
                reject?(.retrieval(error))
                return
            }
            if let image = UIImage(data: imageData) {
                resolve(image)
            } else {
                reject?(.serialization)
            }
            
        }.resume()
    }
    
}
