//
//  ErrorHandling.swift
//  Mercury
//
//  Created by Vikramjeet Singh on 7/27/16.
//  Copyright © 2016 Vikramjeet Singh. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(ErrorProtocol)
}

extension Result {
    var value: T? {
        switch self {
        case .success(let res):
            return res
        case .failure(_):
            return nil
        }
    }
    
    var error: ErrorProtocol? {
        switch self {
        case .success(_):
            return nil
        case .failure(let error):
            return error
        }
    }
}

enum MercuryError: ErrorProtocol {
    case Empty
}

extension MercuryError: CustomStringConvertible {
    var description: String {
        switch self {
        case .Empty:
            return "Found Empty value"
        }
    }
}

enum AuthorizationError: ErrorProtocol {
    case InvalidCredentials
    case EmptyField
}

extension AuthorizationError: CustomStringConvertible {
    var description: String {
        switch self {
        case .InvalidCredentials:
            return "Invalid Email Address and/or Password provided"
        case .EmptyField:
            return "Email and Password fields should not be empty"
        }
    }
}
