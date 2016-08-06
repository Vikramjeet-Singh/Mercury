//
//  NetworkManager.swift
//  Mercury
//
//  Created by Vikramjeet Singh on 7/27/16.
//  Copyright © 2016 Vikramjeet Singh. All rights reserved.
//

import Foundation
import Firebase

/**
 NetworkManager class is a singleton service class that interacts with Firebase.
 All FIrebase callbacks are coming back on Main thread
 */
final class NetworkManager: Queuable {
    static let shared = NetworkManager()
    
    private let userService: UserService = UserService(withEndpoint: Endpoint.users.value)
    
    private(set) lazy var operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "Network queue"
        queue.maxConcurrentOperationCount = 3
        return queue
    }()
}

private extension NetworkManager {
    enum Endpoint {
        case base
        case users
        case message
//        case user(String)
        
        var dbBaseRef: FIRDatabaseReference {
            return FIRDatabase.database().reference()
        }
        
        var value: FIRDatabaseReference! {
            switch self {
            case .base:
                return dbBaseRef
            case .users:
                return dbBaseRef.child("users")
            case .message:
                return dbBaseRef.child("messages")
//            case .user(let id):
//                return dbBaseRef.child("users").child(id)
            }
        }
    }
}

extension NetworkManager {
    typealias ResultBlock<T> = (Result<T>) -> Void
    
    //MARK: User management functions
    static func createUser(resource: Resource<User>, completion: ResultBlock<User>? = nil) {
        NetworkManager.shared.userService.createUser(resource: resource, completion: completion)
    }
    
    static func signIn(resource: Resource<User>, completion: ResultBlock<User>? = nil) {
        NetworkManager.shared.userService.signIn(resource: resource, completion: completion)
    }
    
    static func signout(resource: Resource<Void>, completion: ResultBlock<Void>? = nil) {
        NetworkManager.shared.userService.signout(resource: resource, completion: completion)
    }
    
    static func save(user: Resource<User>, completion: ResultBlock<User>? = nil) {
        NetworkManager.shared.userService.save(resource: user, completion: completion)
    }

/*
    // MARK: Message network functions
    static func postJoke(resource: Resource<String>, completion: ResultBlock<String>? = nil) {
        NetworkManager.shared.enQueue({
            // set/post joke in db
            Endpoint.message.value.childByAutoId().setValue(resource.data, withCompletionBlock: {error, dbReference in
                print("DB reference returned is : \(dbReference)")
                completion?(resource.result(dbReference, error))
            })
        })
    }
    
    //    static func load<T>(resource: Resource<T>, completion: ResultBlock<T>? = nil) {
    //        // fetch jokes
    //    }
    
    static func observe<T>(resource: Resource<T>, completion: ResultBlock<T>? = nil) {
        NetworkManager.shared.enQueue({
            Endpoint.message.value.observe(.value, with: { snapshot in
                print("Snapshot is : \(snapshot)")
                completion?(resource.result(snapshot, nil))
            })
        })
    }
 */
}

protocol Queuable {
    var operationQueue: OperationQueue { get }
}

extension Queuable {
    func enQueue(_ opBlock: () -> Void) {
        let operation = BlockOperation(block: opBlock)
        operationQueue.addOperation(operation)
    }
}
