//
//  User.swift
//  Mercury
//
//  Created by Vikramjeet Singh on 7/27/16.
//  Copyright © 2016 Vikramjeet Singh. All rights reserved.
//

import Foundation
import Firebase

final class User: Equatable  {
    private var firUser: FIRUser?
    
    private var _uid: String!
    private var _email: String!
    private var _name: String!
    private var _age: String?
    private var _interests: String?
    private var _location: String?
    private var _kids: String?
    private var _pets: String?
    private var _photoURL: URL?
    
    // TODO: Use sparingly. Will take it out when firebase is gone
    init?(firUser: FIRUser) {
        self.firUser = firUser
    }
    
    init?(dictionary: [String : AnyObject]) {
        guard let uid = dictionary["id"] as? String,
            let email = dictionary["email"] as? String,
            let name = dictionary["name"] as? String else { return nil }
        
        self._uid = uid
        self._email = email
        self._name = name
        
        self.initialize(dict: dictionary)
    }
    
    init(id: String, dictionary: [String : AnyObject]) {
        self._uid = id
        self._photoURL = dictionary["photoURL"] as? URL
        
        guard let email = dictionary["email"] as? String,
            let name = dictionary["name"] as? String else { return }
        
        self._email = email
        self._name = name
        
        self.initialize(dict: dictionary)
    }
    
    private func initialize(dict: [String : AnyObject]) {
        self._age = dict["age"] as? String
        self._interests = dict["interests"] as? String
        self._location = dict["location"] as? String
        self._kids = dict["kids"] as? String
        self._pets = dict["pets"] as? String
        self._photoURL = dict["photoURL"] as? URL
    }
}

extension User {
    var uid: String {
        return self.firUser?.uid ?? self._uid
    }

    var email: String {
        return self.firUser?.email ?? self._email
    }
    
    var name: String {
        return self.firUser?.displayName ?? self._name
    }
    
    var photoURL: URL? {
        return self.firUser?.photoURL ?? self._photoURL
    }
}

extension User {
    static func createUser(email: String, password: String, username: String, completion: (Result<User>) -> Void) throws {
        let createUser = try userResource(withEmail: email, password: password, username: username)
        // Make Server request
        NetworkManager.createUser(resource: createUser) { result in
            completion(result)
        }
    }
    
    static func signIn(email: String, password: String, completion: (Result<User>) -> Void) throws {
        let signIn = try userResource(withEmail: email, password: password)
        // Make Server request
        NetworkManager.signIn(resource: signIn) { result in
            completion(result)
        }
    }
    
    static func signOut(completion: (Result<Void>) -> Void ) {
        let signOut = Resource<Void>(method: .post(data: nil)) { _, error in
            if let error = error { return .failure(error) }
            
            // Update current user
            CurrentUser.delete()
            return .success()
        }
        
        // Make Server request
        NetworkManager.signout(resource: signOut, completion: { result in
            completion(result)
        })
    }
    
    static func save(_ user: User,
                     asCurrentUser: Bool = true,
                     completion: ((Result<User>) -> Void)? = nil)
    {
        if asCurrentUser {
            // Save and Update current user
            CurrentUser.save(userID: user.uid, email: user.email, name: user.name)
        }
        
        let userRes: Resource<User> = Resource(method: .post(data: ["user" : user]), result: { _, error in
            if let error = error { return .failure(error) }
            return .success(user)
        })
        
        // Make Server Request
        NetworkManager.save(user: userRes, completion: { result in
            completion?(result)
        })
    }
    
    static func update(userID id: String, withDictionary dict: [String : AnyObject], completion: ((Result<Bool>) -> Void)? = nil) throws {
        guard !dict.isEmpty else { return }
        
        // Create mutable copy and add user id key
        var dataDict = dict
        dataDict["userID"] = id
        
        let userResource = Resource<Bool>(method: .post(data: dataDict), result: { _, error in
            if let error = error { return .failure(error) }
            return .success(true)
        })
        
        // Make Server Request
        NetworkManager.updateProfile(user: userResource, completion: { result in
            completion?(result)
        })
    }
}

private extension User {
    static func userResource(withEmail emailAddr: String,
                             password: String,
                             username: String = "Undefined") throws -> Resource<User>
    {
        // Create actual resource
        let email = try emailAddr.validatedEmail()
        let password = try password.validatedPassword()
        let username = try username.validatedUsername()
        
        let data = ["email" :  email, "password" : password]
        
        return Resource<User>(method: .post(data: data), result: { (firUser, error) in
            // Crash if user is not FIRUser
            guard let firUsr = firUser as? FIRUser else { return .failure(error!) }
            
            // Create user model
            let user = User(dictionary: ["id"    : firUsr.uid,
                                         "email" : email,
                                         "name"  : username])!
            
            // save user
            User.save(user)
            return .success(user)
        })
    }
}

extension User {
    
    static let all = Resource<[User]>(method: .get(url: ""), result: { snapshot, error in
        guard let snapshot = snapshot as? FIRDataSnapshot,
            let snaps = snapshot.children.allObjects as? [FIRDataSnapshot]  else { return .failure(error!) }
        
        // Create user model
        let users: [User] = snaps.flatMap { User(id: $0.key, dictionary: $0.value as! [String : AnyObject]) }
        return .success(users)
    })
    
}

extension User: Observer {
    static func observe(forResource resource: Resource<[User]>, callback: ([User]) -> Void) {
        NetworkManager.observeUsers(resource: resource, completion: { result in
            // check result and update users array
            guard let value = result.value else { return print("Error while retrieving users") }
            callback(value)
        })
    }
}

// TODO: Use Realm and then cache current user. Would have to change this class
// Can this be a protocol?
struct CurrentUser {
    
    static var uid: String? {
        get {
            return UserDefaults.standard.value(forKey: UserKeys.id.rawValue) as? String
        }
    }
    static var email: String? {
        get {
            return UserDefaults.standard.value(forKey: UserKeys.email.rawValue) as? String
        }
    }
    static var name: String? {
        get {
            return UserDefaults.standard.value(forKey: UserKeys.name.rawValue) as? String
        }
    }
    static var photoData: Data? {
        get {
            return UserDefaults.standard.value(forKey: UserKeys.photoData.rawValue) as? Data
        }
    }

    static func save(userID: String, email: String, name: String?, photoURL: Data? = nil) {
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(userID, forKey: UserKeys.id.rawValue)
        userDefaults.set(email, forKey: UserKeys.email.rawValue)
        userDefaults.set(name ?? "Undefined", forKey: UserKeys.name.rawValue)
        userDefaults.set(photoURL, forKey: UserKeys.photoData.rawValue)
        
        userDefaults.synchronize()
    }
    
    static func delete() {
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(nil, forKey: UserKeys.id.rawValue)
        userDefaults.set(nil, forKey: UserKeys.email.rawValue)
        userDefaults.set(nil, forKey: UserKeys.name.rawValue)
        userDefaults.set(nil, forKey: UserKeys.photoData.rawValue)
        
        userDefaults.synchronize()
    }
    
}

func ==(_ lhs: User, _ rhs: User) -> Bool {
    return lhs.uid == rhs.uid
}
