import UIKit

struct Link {
    var id: String
    var name: String?
    var title: String?
    var url: URL
    var author: String?
    var date: Date
    var domain: String
    var isOver18: Bool
    var permalink: String
    var postHint: String?
    var thumbnail: Thumbnail?
    var viewCount: Int
    var commentsCount: Int
    var crosspostsCount: Int
    var likesCount: Int
    var upsCount: Int
}

extension Link: Decodable {
    
    enum CodingKey: String, Swift.CodingKey {
        case id
        case title
        case url
        case name
        case domain
        case author
        case created = "created_utc"
        case isOver18 = "over_18"
        case permalink
        case postHint = "post_hint"
        case thumbnailURL = "thumbnail"
        case thumbnailWidth = "thumbnail_width"
        case thumbnailHeight = "thumbnail_height"
        case viewCount = "view_count"
        case commentsCount = "num_comments"
        case crosspostsCount = "num_crossposts"
        case likesCount = "likes"
        case upsCount = "ups"
        case subreddit
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKey.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String?.self, forKey: .name)
        title = try container.decode(String?.self, forKey: .title)
        author = try container.decode(String?.self, forKey: .author)
        domain = try container.decode(String.self, forKey: .domain)
        isOver18 = try container.decode(Bool.self, forKey: .isOver18)
        permalink = try container.decode(String.self, forKey: .permalink)
        postHint = try? container.decode(String.self, forKey: .postHint)
        viewCount = try container.decode(Int?.self, forKey: .viewCount) ?? 0
        commentsCount = try container.decode(Int?.self, forKey: .commentsCount) ?? 0
        crosspostsCount = try container.decode(Int?.self, forKey: .crosspostsCount) ?? 0
        likesCount = try container.decode(Int?.self, forKey: .likesCount) ?? 0
        upsCount = try container.decode(Int?.self, forKey: .upsCount) ?? 0
        url = try container.decode(URL.self, forKey: .url)
        date = try {
            let timestamp = try container.decode(Double.self, forKey: .created)
            return Date(timeIntervalSince1970: timestamp)
        }()
        thumbnail = try {
            let urlString = try container.decode(String?.self, forKey: .thumbnailURL)
            let thumbnailWidth = try container.decode(Int?.self, forKey: .thumbnailWidth)
            let thumbnailHeight = try container.decode(Int?.self, forKey: .thumbnailHeight)
            guard let url = urlString.flatMap(URL.init), let width = thumbnailWidth, let height = thumbnailHeight else {
                return nil
            }
            return Thumbnail(
                url: url,
                size: CGSize(width: width, height: height)
            )
        }()
    }
    
}
