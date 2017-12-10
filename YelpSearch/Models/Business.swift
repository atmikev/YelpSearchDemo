//
//  Business.swift
//  YelpSearch
//
//  Created by Tyler Mikev on 12/9/17.
//  Copyright © 2017 Tyler Mikev. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON

struct Business {
    let rating: Int
    let price: String
    let phone: String
    let id: String
    let isClosed: Bool
    let categories: [BusinessCategory]
    let reviewCount: Int
    let name: String
    let url: String
    let coordinates: CLLocationCoordinate2D
    let imageURL: String
    let location: Address
    let distance: Float
    let transactions: [String]
    var reviews = [Review]()
    
    var ratingString: String {
        return String(repeating:"\u{2B50}", count: rating)
    }
    
    var priceString: String {
        return String(repeating:"\u{1F4B0}", count: price.count)
    }
    
    init(from json: JSON) {
        rating = json["rating"].intValue
        price = json["price"].stringValue
        phone = json["phone"].stringValue
        id = json["id"].stringValue
        isClosed = json["is_closed"].boolValue
        categories = json["categories"].map { (key, json) in BusinessCategory(from: json)}
        reviewCount = json["review_count"].intValue
        name = json["name"].stringValue
        url = json["url"].stringValue
        imageURL = json["image_url"].stringValue
        location = Address(from: json["location"])
        distance = json["distance"].floatValue
        transactions = json["transactions"].arrayValue.map({$0.stringValue})
        
        let coordinateJSON = json["coordinate"]
        let latitude = coordinateJSON["latitude"].floatValue
        let longitude = coordinateJSON["longitude"].floatValue
        coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
    }
}
