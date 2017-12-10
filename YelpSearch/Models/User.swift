//
//  User.swift
//  YelpSearch
//
//  Created by Tyler Mikev on 12/10/17.
//  Copyright © 2017 Tyler Mikev. All rights reserved.
//

import Foundation
import SwiftyJSON

struct User {
    
    let imageURL: String
    let name: String
    
    init(from json: JSON) {
        self.imageURL = json["image_url"].stringValue
        self.name = json["name"].stringValue
    }
}
