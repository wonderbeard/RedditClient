//
//  ViewController.swift
//  RedditClient
//
//  Created by Andrew Malyarchuk on 12.03.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

import UIKit

class ItemListViewController: UITableViewController {
    
    var dateMapper = AnyMapper(DateMapper(format: "d MMM H:mm"))
    var commentsCountMapper = AnyMapper<Int, String?>{ "comments: \($0)" }
    var upsCountMapper = AnyMapper<Int, String?>{ "ups: \($0)" }
    
    private let model = ItemListModel()
    private var items: [Link] = []
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mockDataURL = Bundle.main.url(forResource: "RedditTop", withExtension: "json")!
        displayItems(from: mockDataURL)
        
        model.didLoadItems { items in
            self.items = items
            self.tableView.reloadData()
        }
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
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusable(.itemCell, for: indexPath)
        let item = items[indexPath.row]
        cell.setViewModel(ItemCellViewModel(
            thumbnailVisible: (item.thumbnail != nil),
            title: item.title,
            credentialsText: dateMapper.map(item.date) + (item.author.map{ " by \($0)" } ?? ""),
            commentsText: commentsCountMapper.map(item.commentsCount),
            upsText: upsCountMapper.map(item.upsCount)
        ))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        let itemCell = cell as! ItemTableViewCell
        item.thumbnail.map{ $0.url }.map(itemCell.thumbnailImageView.setImage)
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let itemCell = cell as! ItemTableViewCell
        itemCell.thumbnailImageView.cancelImageLoad()
    }

}

private extension Reusable {
    static var itemCell: Reusable<ItemTableViewCell> { return #function }
}
