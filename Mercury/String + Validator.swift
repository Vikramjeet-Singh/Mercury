//
//  String + Validator.swift
//  Mercury
//
//  Created by Vikramjeet Singh on 7/27/16.
//  Copyright © 2016 Vikramjeet Singh. All rights reserved.
//

import Foundation

extension String {
    func validatedEmail() throws -> String {
        guard !self.isEmpty else { throw AuthorizationError.InvalidEmail }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let email = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        guard email.evaluate(with: self) else {
            throw AuthorizationError.InvalidEmail
        }
        
        return self
    }
    
    func validatedUsername() throws -> String {
        if self.isEmpty {
            throw AuthorizationError.InvalidUsername
        }
        
        return self
    }
    
    func validatedPassword() throws -> String {
        if self.isEmpty {
            throw AuthorizationError.InvalidPassword
        }
        
        return self
    }
}
