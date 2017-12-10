//
//  ResultEnum.swift
//  YelpSearch
//
//  Created by Tyler Mikev on 12/9/17.
//  Copyright © 2017 Tyler Mikev. All rights reserved.
//

enum Result<T> {
    case Success(T)
    case Failure(Error)
}
