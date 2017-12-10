//
//  Network.swift
//  YelpSearch
//
//  Created by Tyler Mikev on 12/9/17.
//  Copyright © 2017 Tyler Mikev. All rights reserved.
//

import Moya
import SwiftyJSON

struct Network {
    static let provider = MoyaProvider<YelpService>()
    
    static func request(target: YelpService,
                        success successCallback: @escaping (JSON) -> Void,
                        error errorCallback: @escaping (Error) -> Void,
                        failure failureCallback: @escaping (MoyaError) -> Void) {

        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    try _ = response.filterSuccessfulStatusCodes()
                    let json = try JSON(response.mapJSON())
                    successCallback(json)
                }
                catch let error {
                    errorCallback(error)
                }
            case let .failure(error):
                failureCallback(error)
            }
        }
        
    }
    
}
