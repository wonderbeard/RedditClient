//
//  ViewController.swift
//  RedditClient
//
//  Created by Andrew Malyarchuk on 12.03.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

import UIKit

class ItemListViewController: UITableViewController {
    
    private let model = ItemListModel()
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM H:mm"
        return formatter
    }()
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mockDataURL = Bundle.main.url(forResource: "RedditTop", withExtension: "json")!
        displayItems(from: mockDataURL)
        
        model.didLoadItems(tableView.reloadData)
        model.didFailLoadingItems { error in
            // todo
        }
    }
    
    // MARK: - Public
    
    func displayItems(from url: URL) {
        model.loadItems(from: url)
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemTableViewCell
        let item = model.items[indexPath.row]
        cell.titleLabel.text = item.title
        cell.credentialsLabel.text = dateFormatter.string(from: item.date) + (item.author.map{ " by \($0)" } ?? "")
        cell.commentsLabel.text = "comments: \(item.commentsCount)"
        cell.upsLabel.text = "ups: \(item.upsCount)"
        cell.thumbnailImageView.isHidden = (item.thumbnail == nil)
        return cell
    }

}

