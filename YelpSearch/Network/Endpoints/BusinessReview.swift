//
//  BusinessReview.swift
//  YelpSearch
//
//  Created by Tyler Mikev on 12/10/17.
//  Copyright © 2017 Tyler Mikev. All rights reserved.
//

import Foundation
import SwiftyJSON

struct BusinessReviewRequest {
    let business: Business
    
    init(business: Business) {
        self.business = business
    }
}

struct BusinessReviewResponse {
    
    let total: Int
    let possibleLanguages: [String]
    let reviews: [Review]
    
    static var sampleData: Data {
        return "{\"reviews\": [{\"rating\": 5,\"user\": {\"image_url\": \"https://s3-media3.fl.yelpcdn.com/photo/iwoAD12zkONZxJ94ChAaMg/o.jpg\",\"name\": \"Ella A.\"},\"text\": \"Went back again to this place since the last time i visited the bay area 5 months ago, and nothing has changed. Still the sketchy Mission, Still the cashier...\",\"time_created\": \"2016-08-29 00:41:13\",\"url\": \"https://www.yelp.com/biz/la-palma-mexicatessen-san-francisco?hrid=hp8hAJ-AnlpqxCCu7kyCWA&adjust_creative=0sidDfoTIHle5vvHEBvF0w&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_reviews&utm_source=0sidDfoTIHle5vvHEBvF0w\"},{\"rating\": 4,\"user\": {\"image_url\": null,\"name\": \"Yanni L.\"},\"text\": \"The \"restaurant\" is inside a small deli so there is no sit down area. Just grab and go.\n\nInside, they sell individually packaged ingredients so that you can...\",\"time_created\": \"2016-09-28 08:55:29\",\"url\": \"https://www.yelp.com/biz/la-palma-mexicatessen-san-francisco?hrid=fj87uymFDJbq0Cy5hXTHIA&adjust_creative=0sidDfoTIHle5vvHEBvF0w&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_reviews&utm_source=0sidDfoTIHle5vvHEBvF0w\"},{\"rating\": 4,\"user\": {\"image_url\": null,\"name\": \"Suavecito M.\"},\"text\": \"Dear Mission District,\n\nI miss you and your many delicious late night food establishments and vibrant atmosphere.  I miss the way you sound and smell on a...\",\"time_created\": \"2016-08-10 07:56:44\",\"url\": \"https://www.yelp.com/biz/la-palma-mexicatessen-san-francisco?hrid=m_tnQox9jqWeIrU87sN-IQ&adjust_creative=0sidDfoTIHle5vvHEBvF0w&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_reviews&utm_source=0sidDfoTIHle5vvHEBvF0w\"}],\"total\": 3,\"possible_languages\": [\"en\"]}".utf8Encoded
    }
    
    init(from json: JSON) {
        total = json["total"].intValue
        possibleLanguages = json["possible_languages"].arrayValue.map { $0.stringValue }
        reviews = json["reviews"].arrayValue.map { Review(from: $0) }.sorted { $0.timeCreated > $1.timeCreated }
    }
}
