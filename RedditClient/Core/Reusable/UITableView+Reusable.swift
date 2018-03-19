//
//  UITableView+Reusable.swift
//  RedditClient
//
//  Created by Andrew Malyarchuk on 19.03.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

import UIKit

extension UITableView {
    
    func dequeueReusable<Cell>(_ cell: Reusable<Cell>) -> Cell? {
        return dequeueReusableCell(withIdentifier: cell.reuseIdentifier) as? Cell
    }
    
    func dequeueReusable<Cell>(_ cell: Reusable<Cell>, for indexPath: IndexPath) -> Cell {
        return dequeueReusableCell(withIdentifier: cell.reuseIdentifier, for: indexPath) as! Cell
    }
    
}
