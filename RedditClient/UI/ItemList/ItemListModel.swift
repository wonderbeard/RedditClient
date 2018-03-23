//
//  ItemListModel.swift
//  RedditClient
//
//  Created by Andrew Malyarchuk on 19.03.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

import Foundation

class ItemListModel {
    
    private let queue: DispatchQueue
    private let jsonDecoder: JSONDecoder
    private let itemsSubject = Subject<[Link]>(replay: 1)
    private let errorSubject = Subject<Error>(replay: 1)
    
    init(
        queue: DispatchQueue = .global(qos: .userInitiated),
        jsonDecoder: JSONDecoder = JSONDecoder())
    {
        self.queue = queue
        self.jsonDecoder = jsonDecoder
    }
    
    func didLoadItems(_ observer: @escaping ([Link]) -> Void) {
        itemsSubject.subscribe(observer)
    }
    
    func didFailLoadingItems(_ observer: @escaping (Error) -> Void) {
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
    
}
