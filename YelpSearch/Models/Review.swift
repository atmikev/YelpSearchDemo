//
//  Review.swift
//  YelpSearch
//
//  Created by Tyler Mikev on 12/10/17.
//  Copyright © 2017 Tyler Mikev. All rights reserved.
//

import Foundation
import SwiftyJSON
struct Review {
    
    let rating: Int
    let user: User
    let text: String
    let timeCreated: Date
    
    var ratingString: String {
        return String(repeating:"\u{2B50}", count: rating)
    }
    
    init(from json: JSON) {
        rating = json["rating"].intValue
        user = User(from: json["user"])
        text = json["text"].stringValue
        
        let timeString = json["time_created"].stringValue
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "PST")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        timeCreated = dateFormatter.date(from: timeString)!
    }
}
