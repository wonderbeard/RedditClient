//
//  AppDelegate.swift
//  RedditClient
//
//  Created by Andrew Malyarchuk on 12.03.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        
        let jsonData = Bundle.main
            .url(forResource: "RedditTop", withExtension: "json")
            .flatMap{ try? Data(contentsOf: $0) }
        
        let jsonDecoder = JSONDecoder()
        
        do {
            let listingResponse = try jsonDecoder.decode(Thing<Listing<Thing<Link>>>.self, from: jsonData!)
            let links = listingResponse.data.children.map{ $0.data }
        } catch {
            print(error)
        }
        
    }
    
}

