//
//  YelpService.swift
//  YelpSearch
//
//  Created by Tyler Mikev on 12/9/17.
//  Copyright © 2017 Tyler Mikev. All rights reserved.
//

import Foundation
import Moya

enum YelpService {
    case getBusinesses(request: SearchBusinessesRequest)
}

extension YelpService: TargetType {
    
    var baseURL: URL { return URL(string: "https://api.yelp.com/v3")! }
    
    var path: String {
        switch self {
        case .getBusinesses(_):
            return "/businesses/search"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getBusinesses(_):
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .getBusinesses(request):
            return .requestParameters(parameters: request.parameters, encoding: URLEncoding.queryString)
        }
    }

    var sampleData: Data {
        switch self {
        case .getBusinesses(_):
            return SearchBusinessesResponse.sampleData
        }
    }
    
    var headers: [String: String]? {
        return [
            "Content-type": "application/json",
            "Authorization": "Bearer tUoI6vQL1dM7nMACxEykVMtslEyrSVgUAt8XldltcK7SWnVi46DlbcNRz4Gbu1KOSLceeWzfZjkGExE4bnd7vMlnZo9FnjKDMGBTzOLnhX2E01vqJ-XiyCGktKYsWnYx"
        ]
    }
}
