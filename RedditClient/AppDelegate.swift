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

    let bundle = Bundle.main
    let window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        
        let storyboard = UIStoryboard(name: "ItemListViewController", bundle: bundle)
        let itemListVC = storyboard.instantiateInitialViewController() as! ItemListViewController
        
        let mockDataURL = bundle.url(forResource: "RedditTop", withExtension: "json")!
        itemListVC.displayItems(from: mockDataURL)
        
        window?.rootViewController = itemListVC
        window?.makeKeyAndVisible()
    }
    
}

