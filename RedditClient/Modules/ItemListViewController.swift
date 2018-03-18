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

    override func viewDidLoad() {
        super.viewDidLoad()
        model.didLoadItems { [unowned self] in
            self.tableView.reloadData()
        }
        model.didFailLoadingItems { error in
            // todo
        }
    }
    
    func displayItems(from url: URL) {
        model.loadItems(from: url)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = model.items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = "Ups: \(item.upsCount)"
        return cell
    }

}

