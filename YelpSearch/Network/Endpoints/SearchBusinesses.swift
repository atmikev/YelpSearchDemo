//
//  SearchBusinesses.swift
//  YelpSearch
//
//  Created by Tyler Mikev on 12/9/17.
//  Copyright © 2017 Tyler Mikev. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON

struct SearchBusinessesRequest {
    let coordinate: CLLocationCoordinate2D
    let searchTerm: String
    
    var parameters: [String: Any] {
        return [
            "latitude": coordinate.latitude,
            "longitude": coordinate.longitude,
            "term": searchTerm,
        ]
    }
    
    init(at coordinate: CLLocationCoordinate2D, with searchTerm: String) {
        self.searchTerm = searchTerm
        self.coordinate = coordinate
    }

}

struct SearchBusinessesResponse {
    
    let total: Int
    let businesses: [Business]
    let regionCenter: CLLocationCoordinate2D
    
    static var sampleData: Data {
        return "{\"total\": 1,\"businesses\": [{\"rating\": 4,\"price\": \"$\",\"phone\": \"+14152520800\",\"id\": \"four-barrel-coffee-san-francisco\",\"is_closed\": false,\"categories\": [{\"alias\": \"coffee\",\"title\": \"Coffee & Tea\"}],\"review_count\": 1738,\"name\": \"Four Barrel Coffee\",\"url\": \"https://www.yelp.com/biz/four-barrel-coffee-san-francisco\",\"coordinates\": {\"latitude\": 37.7670169511878,\"longitude\": -122.42184275},\"image_url\": \"http://s3-media2.fl.yelpcdn.com/bphoto/MmgtASP3l_t4tPCL1iAsCg/o.jpg\",\"location\": {\"city\": \"San Francisco\",\"country\": \"US\",\"address2\": \"\",\"address3\": \"\",\"state\": \"CA\",\"address1\": \"375 Valencia St\",\"zip_code\": \"94103\"},\"distance\": 1604.23,\"transactions\": [\"pickup\", \"delivery\"]},],\"region\": {\"center\": {\"latitude\": 37.767413217936834,\"longitude\": -122.42820739746094}}}".utf8Encoded
    }
    
    init(from json:JSON) {
        total = json["total"].intValue
        businesses = json["businesses"].arrayValue.map { Business(from: $0) }
        
        let latitude = json["region"]["center"]["latitude"].floatValue
        let longitude = json["region"]["center"]["longitude"].floatValue
        regionCenter = CLLocationCoordinate2DMake(CLLocationDegrees(latitude), CLLocationDegrees(longitude))
    }
}
