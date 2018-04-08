//
//  ImageViewerView.swift
//  RedditClient
//
//  Created by Andrew Malyarchuk on 08.04.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

import UIKit

class ImageViewerView: UIView {
    
    private enum Defaults {
        static let maxZoomScale: CGFloat = 1.0
    }
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.maximumZoomScale = Defaults.maxZoomScale
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeViewHierarchy()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeViewHierarchy()
    }
    
    override func layoutSubviews() {
        invalidateMinZoomScale()
        super.layoutSubviews()
        adjustImagePosition()
    }
    
    // MARK: - Public
    
    var zoomScale: CGFloat {
        get { return scrollView.zoomScale }
        set(scale) { scrollView.zoomScale = scale }
    }
    
    var minZoomScale: CGFloat {
        get { return scrollView.minimumZoomScale }
        set(scale) { scrollView.minimumZoomScale = scale }
    }
    
    var maxZoomScale: CGFloat {
        get { return scrollView.maximumZoomScale }
        set(scale) { scrollView.maximumZoomScale = scale }
    }
    
    var isZoomed: Bool {
        return zoomScale > minZoomScale
    }
    
    func zoomOut(animated: Bool) {
        scrollView.setZoomScale(minZoomScale, animated: animated)
    }
    
    func zoomIn(_ center: CGPoint, animated: Bool) {
        let xOffset = center.x - bounds.width / 2
        let yOffset = center.y - bounds.height / 2
        let rect = CGRect(origin: CGPoint(x: xOffset, y: yOffset), size: bounds.size)
        scrollView.zoom(to: rect, animated: animated)
    }
    
    var image: UIImage? {
        get { return imageView.image }
        set(image) {
            imageView.bounds = CGRect(origin: .zero, size: image?.size ?? .zero)
            imageView.image = image
        }
    }
    
    func setScrollViewDelegate(_ delegate: UIScrollViewDelegate?) {
        scrollView.delegate = delegate
    }
    
    func adjustImagePosition() {
        let yOffset = max(0, (bounds.size.height - imageView.frame.height) / 2)
        let xOffset = max(0, (bounds.size.width - imageView.frame.width) / 2)
        imageView.frame.origin = CGPoint(x: xOffset, y: yOffset)
    }
    
    func invalidateMinZoomScale() {
        let minScale = minZoomScaleForViewSize(bounds.size)
        scrollView.minimumZoomScale = minScale
        if scrollView.zoomScale < minScale {
            scrollView.zoomScale = minScale
        }
    }
    
    // MARK: - Private
    
    private func initializeViewHierarchy() {
        scrollView.addSubview(imageView)
        insertSubview(scrollView, at: 0)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            topAnchor.constraint(equalTo: scrollView.topAnchor),
            bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    private func minZoomScaleForViewSize(_ size: CGSize) -> CGFloat {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        return minScale
    }
    
}
