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
    private let listingSubject = Subject<Void>(replay: 1)
    private let errorSubject = Subject<Error>(replay: 1)
    
    private(set) var items: [Link] = []
    
    init(
        queue: DispatchQueue = .global(qos: .userInitiated),
        jsonDecoder: JSONDecoder = JSONDecoder())
    {
        self.queue = queue
        self.jsonDecoder = jsonDecoder
    }
    
    func didLoadItems(_ observer: @escaping () -> Void) {
        listingSubject.subscribe(observer)
    }
    
    func didFailLoadingItems(_ observer:  @escaping (Error) -> Void) {
        errorSubject.subscribe(observer)
    }
    
    func loadItems(from url: URL) {
        queue.async { [unowned self, jsonDecoder] in
            do {
                
                let data = try Data(contentsOf: url)
                let listingThing = try jsonDecoder.decode(Thing<Listing<Thing<Link>>>.self, from: data)
                
                let listing = listingThing.data
                self.items = listing.children.map{ $0.data }
                DispatchQueue.main.async { [unowned self] in
                    self.listingSubject.onNext(())
                }
                
            } catch {
                DispatchQueue.main.async { [unowned self] in
                    self.errorSubject.onNext(error)
                }
            }
        }
    }
    
}
