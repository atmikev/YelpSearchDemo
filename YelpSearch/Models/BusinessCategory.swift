//
//  BusinessCategory.swift
//  YelpSearch
//
//  Created by Tyler Mikev on 12/9/17.
//  Copyright © 2017 Tyler Mikev. All rights reserved.
//

import Foundation
import SwiftyJSON

struct BusinessCategory {
    let alias: String
    let title: String
    
    init(from json: JSON) {
        alias = json["alias"].stringValue
        title = json["title"].stringValue
    }
}
