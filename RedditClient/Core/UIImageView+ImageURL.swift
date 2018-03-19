//
//  UIImageView+ImageURL.swift
//  RedditClient
//
//  Created by Andrew Malyarchuk on 19.03.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

import UIKit
import ObjectiveC

extension UIImageView {
    
    private enum AssociatedKey {
        static var imageURL = "com.wonderbeard.RedditClient.UIImageView.imageURL"
    }
    
    private var currentImageURL: URL? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.imageURL) as? URL
        }
        set(url) {
            objc_setAssociatedObject(self, &AssociatedKey.imageURL, url, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func setImage(with url: URL) {
        cancelImageLoad()
        currentImageURL = url
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let imageData = try? Data(contentsOf: url) else {
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: imageData), let `self` = self, self.currentImageURL == url {
                    self.image = image
                }
            }
        }
    }
    
    func cancelImageLoad() {
        currentImageURL = nil
    }
    
}
