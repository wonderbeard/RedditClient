//
//  LinkListService.swift
//  RedditClient
//
//  Created by Andrew Malyarchuk on 25.03.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

import Foundation

protocol LinkListService {
    func loadItems(success: @escaping ([Link]) -> Void, failure: ((Error?) -> Void)?)
}
