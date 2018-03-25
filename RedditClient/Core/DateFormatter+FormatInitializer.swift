//
//  DateFormatter+FormatInitializer.swift
//  RedditClient
//
//  Created by Andrew Malyarchuk on 19.03.2018.
//  Copyright © 2018 wonderbeard. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    convenience init(_ dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
    }
    
}

