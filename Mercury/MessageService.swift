//
//  MessageService.swift
//  Mercury
//
//  Created by Vikramjeet Singh on 8/14/16.
//  Copyright © 2016 Vikramjeet Singh. All rights reserved.
//

import Foundation
import Firebase

final class MessageService: NetworkService {
    
    typealias ResType = [Message]
    
    let endpoint: FIRDatabaseReference
    
    private(set) lazy var operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "Message Service queue"
        queue.maxConcurrentOperationCount = 3
        return queue
    }()
    
    init(withEndpoint endpoint: FIRDatabaseReference) {
        self.endpoint = endpoint
    }

}
