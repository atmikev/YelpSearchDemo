//
//  Address.swift
//  YelpSearch
//
//  Created by Tyler Mikev on 12/9/17.
//  Copyright © 2017 Tyler Mikev. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Address {
    
    let address1: String
    let address2: String
    let address3: String
    let city: String
    let state: String
    let zipCode: String
    let country: String
    
    init(from json: JSON) {
        address1 = json["address1"].stringValue
        address2 = json["address2"].stringValue
        address3 = json["address3"].stringValue
        city = json["city"].stringValue
        state = json["state"].stringValue
        zipCode = json["zip_code"].stringValue
        country = json["country"].stringValue
    }
}
