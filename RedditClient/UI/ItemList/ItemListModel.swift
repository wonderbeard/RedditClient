//
//  ItemListModel.swift
//  RedditClient
//
//  Created by Andrew Malyarchuk on 19.03.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

import UIKit
import Reactive

class ItemListModel {
    
    private let itemsService: LinkListService
    private let imageLoader: ImageLoader
    
    private let itemsSubject = ReplaySubject<[Link]>(replay: 1)
    private let errorSubject = ReplaySubject<Error?>(replay: 1)
    private var imageLoads: [URL: Cancelable] = [:]
    
    init(
        itemsService: LinkListService = MockRedditTopService(url: Bundle.main.url(forResource: "RedditTop", withExtension: "json")!),
        imageLoader: ImageLoader = ImageLoaderWithCache(source: DefaultImageLoader()))
    {
        self.itemsService = itemsService
        self.imageLoader = imageLoader
    }
    
    func onItems(_ observer: @escaping ([Link]) -> Void) {
        itemsSubject.subscribe(observer)
    }
    
    func onItemsLoadingError(_ observer: @escaping (Error?) -> Void) {
        errorSubject.subscribe(observer)
    }
    
    func loadItems() {
        itemsService.loadItems(
            success: itemsSubject.onNext,
            failure: errorSubject.onNext
        )
    }
    
    func loadImage(with url: URL, then resultHandler: @escaping (UIImage) -> Void) {
        imageLoads[url] = imageLoader.loadImage(url: url).subscribe(resultHandler)
    }
    
    func cancelImageLoad(with url: URL) {
        imageLoads[url]?.cancel()
        imageLoads[url] = nil
    }
    
}
