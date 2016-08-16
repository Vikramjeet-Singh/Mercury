//
//  MessageViewModel.swift
//  Mercury
//
//  Created by Vikramjeet Singh on 8/10/16.
//  Copyright © 2016 Vikramjeet Singh. All rights reserved.
//

import Foundation

/*
struct MessageViewModel: ViewModel {
    
    var content: [Message] = []
    var didChangeCallback: ([Message]) -> Void = { _ in }
    
    init(changeCallback: ([Message]) -> Void) {
        didChangeCallback = changeCallback
        startObserving(forResource: Message.all)
    }
    
    func startObserving(forResource resource: Resource<[Message]>) {
        NetworkManager.observeMessages(resource: resource, completion: { result in
            // check result and update users array
            guard let value = result.value else { return print("Error while retrieving messages") }
            self.didChangeCallback(value)
        })
    }
    
}

extension MessageViewModel {
    
    func diffed(with other: MessageViewModel) -> Diff<MessageViewModel> {
        let messageChange: DiffChange?
        
        if other.count > self.count {
            let insertedIndices: [Int] = other[(self.count..<other.count)].enumerated().map({ index, _ in
                return self.count + index
            })
            if insertedIndices.isEmpty {
                messageChange = nil
            } else {
                messageChange = .inserted(at: insertedIndices)
            }
        } else if other.count < self.count {
            let removedIndices: [Int] = self[(other.count..<self.count)].enumerated().map({ index, _ in
                return other.count + index
            })
            if removedIndices.isEmpty {
                messageChange = nil
            } else {
                messageChange = .removed(at: removedIndices)
            }
        } else if self.count == other.count {
            let updatedIndices: [Int] = self.enumerated().flatMap({ index, user in
                if user != other[index] { return index }
                return nil
            })
            if updatedIndices.isEmpty {
                messageChange = nil
            } else {
                messageChange = .updated(at: updatedIndices)
            }
        } else {
            fatalError("How are jokes changing other than statements above?")
        }
        
        return Diff(change: messageChange, from: self, to: other)
    }
    
}
*/

