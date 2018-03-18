import Foundation

struct Thing<Data: Decodable> {
    
    enum Kind: String, Codable {
        case listing = "Listing"
        case comment = "t1"
        case account = "t2"
        case link = "t3"
        case message = "t4"
        case subreddit = "t5"
        case award = "t6"
    }
    
    var kind: Kind
    var data: Data
    
}

extension Thing: Decodable {
    
    enum CodingKey: String, Swift.CodingKey {
        case kind, data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKey.self)
        kind = try container.decode(Kind.self, forKey: .kind)
        data = try container.decode(Data.self, forKey: .data)
    }
    
}
