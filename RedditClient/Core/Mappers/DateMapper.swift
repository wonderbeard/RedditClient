//
//  DateTextMapper.swift
//  RedditClient
//
//  Created by Andrew Malyarchuk on 19.03.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

import Foundation

struct DateMapper: Mapper {
    
    var formatter: DateFormatter
    
    init(_ formatter: DateFormatter) {
        self.formatter = formatter
    }
    
    init(format: String) {
        self.init(DateFormatter(format))
    }
    
    func map(_ date: Date) -> String {
        return formatter.string(from: date)
    }
    
}
