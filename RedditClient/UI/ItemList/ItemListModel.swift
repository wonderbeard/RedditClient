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
    
    private let queue: DispatchQueue
    private let jsonDecoder: JSONDecoder
    private let imageLoader: ImageLoader
    
    private let itemsSubject = ReplaySubject<[Link]>(replay: 1)
    private let errorSubject = ReplaySubject<Error>(replay: 1)
    private let imageSubject = PublishSubject<(URL, UIImage)>()
    
    private var imageLoads: [URL: Cancelable] = [:]
    
    init(
        queue: DispatchQueue = .global(qos: .userInitiated),
        jsonDecoder: JSONDecoder = JSONDecoder(),
        imageLoader: ImageLoader = ImageLoaderWithCache(source: DefaultImageLoader()))
    {
        self.queue = queue
        self.jsonDecoder = jsonDecoder
        self.imageLoader = imageLoader
    }
    
    func onItems(_ observer: @escaping ([Link]) -> Void) {
        itemsSubject.subscribe(observer)
    }
    
    func onItemsLoadingError(_ observer: @escaping (Error) -> Void) {
        errorSubject.subscribe(observer)
    }
    
    func loadItems(from url: URL) {
        queue.async { [jsonDecoder, itemsSubject, errorSubject] in
            do {
                
                let data = try Data(contentsOf: url)
                let listingThing = try jsonDecoder.decode(Thing<Listing<Thing<Link>>>.self, from: data)
                
                let listing = listingThing.data
                let items = listing.children.map{ $0.data }
                DispatchQueue.main.async {
                    itemsSubject.onNext(items)
                }
                
            } catch {
                DispatchQueue.main.async {
                    errorSubject.onNext(error)
                }
            }
        }
    }
    
    func loadImage(with url: URL, then resultHandler: @escaping (UIImage) -> Void) {
        imageLoads[url] = imageLoader.loadImage(url: url).subscribe(resultHandler)
    }
    
    func cancelImageLoad(with url: URL) {
        imageLoads[url]?.cancel()
        imageLoads[url] = nil
    }
    
}
