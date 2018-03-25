//
//  ViewController.swift
//  RedditClient
//
//  Created by Andrew Malyarchuk on 12.03.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

import UIKit
import Reactive

class ItemListViewController: UITableViewController {
    
    var dateMapper = AnyMapper(DateMapper(format: "d MMM H:mm"))
    var commentsCountMapper = AnyMapper<Int, String?>{ "comments: \($0)" }
    var upsCountMapper = AnyMapper<Int, String?>{ "ups: \($0)" }
    
    private let model = ItemListModel()
    private var items: [Link] = []
    private var subscriptions: [URL: Cancelable] = [:]
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        model.onItems { items in
            DispatchQueue.main.async {
                self.items = items
                self.tableView.reloadData()
            }
        }
        model.onItemsLoadingError { error in
            // todo
        }
        model.loadItems()
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
        guard let thumbnailURL = items[indexPath.row].thumbnail?.url else {
            return
        }
        model.loadImage(with: thumbnailURL) { image in
            let itemCell = cell as! ItemTableViewCell
            DispatchQueue.main.async {
                itemCell.thumbnailImageView.image = image
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let thumbnailURL = items[indexPath.row].thumbnail?.url {
            model.cancelImageLoad(with: thumbnailURL)
        }
    }

}

private extension Reusable {
    static var itemCell: Reusable<ItemTableViewCell> { return #function }
}
