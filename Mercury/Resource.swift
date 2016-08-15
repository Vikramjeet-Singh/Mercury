//
//  Resource.swift
//  Mercury
//
//  Created by Vikramjeet Singh on 7/27/16.
//  Copyright © 2016 Vikramjeet Singh. All rights reserved.
//

import Foundation
import Firebase

enum RequestMethod {
    case get(url: String)
    case post(data: [String : AnyObject]?)
}

struct Resource<T> {
    let method: RequestMethod
    let result: (AnyObject?, Error?) -> Result<T>
}

extension Resource {
    var data: [String : AnyObject]? {
        switch self.method {
        case .post(let data):
            return data
        default:
            return nil
        }
    }
}
