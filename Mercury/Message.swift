//
//  Message.swift
//  Mercury
//
//  Created by Vikramjeet Singh on 8/7/16.
//  Copyright © 2016 Vikramjeet Singh. All rights reserved.
//

import Foundation
import Firebase

struct Message: Equatable {
    private var id: String
}

extension Message {
    static let all = Resource<[Message]>(method: .get(url: ""), result: { snapshot, error in
        guard let snapshot = snapshot as? FIRDataSnapshot,
            let snaps = snapshot.children.allObjects as? [FIRDataSnapshot] else { return .failure(error!) }
        
        // Create message model
        let messages: [Message] = []
        return .success(messages)
    })
}

func ==(_ lhs: Message, _ rhs: Message) -> Bool {
    return lhs.id == rhs.id
}
