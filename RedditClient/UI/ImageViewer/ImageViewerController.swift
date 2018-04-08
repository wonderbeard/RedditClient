//
//  ImageViewerViewController.swift
//  RedditClient
//
//  Created by Andrew Malyarchuk on 30.03.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

import UIKit
import Reactive

class ImageViewerController: UIViewController, UIScrollViewDelegate {

    private var contentView: ImageViewerView!
    private var isZoomScaleInitiallyAdjusted = false
    
    override func loadView() {
        contentView = ImageViewerView()
        contentView.setScrollViewDelegate(self)
        self.view = contentView
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageDoubleTapRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(ImageViewerController.doubleTapImage)
        )
        imageDoubleTapRecognizer.numberOfTapsRequired = 2
        contentView.addGestureRecognizer(imageDoubleTapRecognizer)
        contentView?.image = #imageLiteral(resourceName: "sample")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isZoomScaleInitiallyAdjusted == false {
            contentView.zoomScale = contentView.minZoomScale
            isZoomScaleInitiallyAdjusted = true
        }
    }
    
    // MARK: - UIScrollViewDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        contentView.adjustImagePosition()
    }
    
    // MARK: - Actions
    
    @objc func doubleTapImage(_ recognizer: UITapGestureRecognizer) {
        guard recognizer.state == .recognized else {
            return
        }
        if contentView.isZoomed {
            contentView.zoomOut(animated: true)
        }
        else {
            let tapLocation = recognizer.location(in: contentView.imageView)
            contentView.zoomIn(tapLocation, animated: true)
        }
    }
    
}
