//
//  UserService.swift
//  Mercury
//
//  Created by Vikramjeet Singh on 7/27/16.
//  Copyright © 2016 Vikramjeet Singh. All rights reserved.
//

import Foundation
import Firebase

final class UserService: Queuable {
    private let endpoint: FIRDatabaseReference
    private(set) lazy var operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "User Service queue"
        queue.maxConcurrentOperationCount = 3
        return queue
    }()
    
    init(withEndpoint endpoint: FIRDatabaseReference) {
        self.endpoint = endpoint
    }
}

extension UserService {
    typealias ResultBlock<T> = (Result<T>) -> Void

    func createUser(resource: Resource<User>, completion: ResultBlock<User>? = nil) {
        guard let email = resource.data?["email"] as? String, let password = resource.data?["password"] as? String else { return }
        enQueue({
            FIRAuth.auth()?.createUser(withEmail: email, password: password) { firUser, error in
                completion?(resource.result(firUser, error))
            }
        })
    }
    
    func signIn(resource: Resource<User>, completion: ResultBlock<User>? = nil) {
        guard let email = resource.data?["email"] as? String, let password = resource.data?["password"] as? String else { return }
        enQueue({
            FIRAuth.auth()?.signIn(withEmail: email, password: password) { firUser, error in
                completion?(resource.result(firUser, error))
            }
        })
    }
    
    func signout(resource: Resource<Void>, completion: ResultBlock<Void>? = nil) {
        enQueue({
            do {
                try FIRAuth.auth()?.signOut()
                completion?(resource.result(true, nil))
            }
            catch {
                completion?(.failure(error))
            }
        })
    }
    
    func save(resource: Resource<User>, completion: ResultBlock<User>? = nil) {
        guard let user = resource.data!["user"] as? User else { return }
        
        let dbReference = endpoint.child(user.uid)
        enQueue {
            dbReference.updateChildValues(["email" : user.email, "name" : user.name],
                                          withCompletionBlock: { error, reference in
                                            completion?(resource.result(reference, error))
            })
        }

    }

}
