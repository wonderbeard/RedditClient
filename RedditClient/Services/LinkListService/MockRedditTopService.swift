//
//  MockRedditTopService.swift
//  RedditClient
//
//  Created by Andrew Malyarchuk on 25.03.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

import Foundation

class MockRedditTopService: LinkListService {
    
    private let url: URL
    private let queue: DispatchQueue
    private let jsonDecoder: JSONDecoder
    
    init(
        url: URL,
        queue: DispatchQueue = .global(qos: .userInitiated),
        jsonDecoder: JSONDecoder = JSONDecoder())
    {
        self.url = url
        self.queue = queue
        self.jsonDecoder = jsonDecoder
    }
    
    func loadItems(success resolve: @escaping ([Link]) -> Void, failure reject: ((Error?) -> Void)?) {
        queue.async { [url, jsonDecoder] in
            do {
                
                let data = try Data(contentsOf: url)
                let listingThing = try jsonDecoder.decode(Thing<Listing<Thing<Link>>>.self, from: data)
                let listing = listingThing.data
                let items = listing.children.map{ $0.data }
                resolve(items)
                
            } catch {
                reject?(error)
            }
        }
    }
    
}
