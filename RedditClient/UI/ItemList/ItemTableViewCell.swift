//
//  ItemTableViewCell.swift
//  RedditClient
//
//  Created by Andrew Malyarchuk on 19.03.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

import UIKit

struct ItemCellViewModel {
    var thumbnailVisible: Bool
    var title: String?
    var credentialsText: String?
    var commentsText: String?
    var upsText: String?
}

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var credentialsLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var upsLabel: UILabel!
    
    func setViewModel(_ viewModel: ItemCellViewModel) {
        thumbnailImageView.isHidden = !viewModel.thumbnailVisible
        titleLabel.text = viewModel.title
        credentialsLabel.text = viewModel.credentialsText
        commentsLabel.text = viewModel.commentsText
        upsLabel.text = viewModel.upsText
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectedBackgroundView = {
            let foo = UIView()
            foo.backgroundColor = .lightGray
            return foo
        }()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let textColor: UIColor = selected ? .white : .black
        titleLabel.textColor = textColor
        credentialsLabel.textColor = textColor
        commentsLabel.textColor = textColor
        upsLabel.textColor = textColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.isHidden = false
        thumbnailImageView.image = nil
        titleLabel.text = nil
        credentialsLabel.text = nil
        commentsLabel.text = nil
        upsLabel.text = nil
    }
    
}
