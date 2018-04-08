import Foundation

struct Listing<Child> {
    
    var children: [Child]
    var pagination: Pagination
    
}

extension Listing: Decodable where Child: Decodable {
    
    enum CodingKey: String, Swift.CodingKey {
        case before, after, dist, children
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKey.self)
        children = try container.decode([Child].self, forKey: .children)
        pagination = Pagination(
            before: try container.decode(String?.self, forKey: .before),
            after: try container.decode(String?.self, forKey: .after),
            distance: try container.decode(Int.self, forKey: .dist)
        )
    }
    
}
