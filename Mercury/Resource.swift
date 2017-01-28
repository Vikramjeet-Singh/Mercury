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
    case post(data: [String : Any]?)
}

struct Resource<T> {
    let method: RequestMethod
    let result: (Any?, Error?) -> Result<T>
}

extension Resource {
    var data: [String : Any]? {
        switch self.method {
        case .post(let data):
            return data
        default:
            return nil
        }
    }
}
