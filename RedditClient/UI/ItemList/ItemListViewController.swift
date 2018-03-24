//
//  ViewController.swift
//  RedditClient
//
//  Created by Andrew Malyarchuk on 12.03.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

import UIKit
import Reactive

enum ImageLoadError: Error {
    case retrieval(Error)
    case notImageData
    case unknown(Error)
}

protocol ImageLoader {
    
    func loadImage(
        url: URL,
        success: @escaping (UIImage) -> Void,
        failure: ((ImageLoadError) -> Void)?
    )
    
}

extension ImageLoader {
    
    func loadImage(
        url: URL,
        then resolve: @escaping (UIImage) -> Void)
    {
        loadImage(url: url, success: resolve, failure: nil)
    }
    
}

struct DefaultImageLoader: ImageLoader {
    
    func loadImage(
        url: URL,
        success resolve: @escaping (UIImage) -> Void,
        failure reject: ((ImageLoadError) -> Void)?)
    {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let imageData = try Data(contentsOf: url)
                if let image = UIImage(data: imageData) {
                    resolve(image)
                }
                else {
                    reject?(.notImageData)
                }
            }
            catch {
                reject?(.retrieval(error))
            }
        }
    }
    
}

struct ImageLoaderWithCache: ImageLoader {
    
    private let sourceLoader: ImageLoader
    private let cache: NSCache<NSString, UIImage>
    
    init(
        source: ImageLoader,
        cache: NSCache<NSString, UIImage> = {
            let cache = NSCache<NSString, UIImage>()
            cache.countLimit = 20
            return cache
        }())
    {
        self.sourceLoader = source
        self.cache = cache
    }
    
    func loadImage(
        url: URL,
        success resolve: @escaping (UIImage) -> Void,
        failure reject: ((ImageLoadError) -> Void)?)
    {
        if let cachedImage = cache.object(forKey: url.absoluteString as NSString) {
            resolve(cachedImage)
        }
        else {
            sourceLoader.loadImage(
                url: url,
                success: { [cache] image in
                    resolve(image)
                    cache.setObject(image, forKey: url.absoluteString as NSString)
                },
                failure: reject
            )
        }
    }
    
}

/////

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
        
        let mockDataURL = Bundle.main.url(forResource: "RedditTop", withExtension: "json")!
        displayItems(from: mockDataURL)
        
        model.onItems { items in
            self.items = items
            self.tableView.reloadData()
        }
        
        model.onItemsLoadingError { error in
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
