//
//  UserViewModel.swift
//  Mercury
//
//  Created by Vikramjeet Singh on 8/10/16.
//  Copyright © 2016 Vikramjeet Singh. All rights reserved.
//

import Foundation


protocol Observer {
    static func observe(forResource resource: Resource<[Self]>, callback: ([Self]) -> Void)
}

struct ListViewModel<Content: Observer & Equatable>: ViewModelProtocol {
    
    var content: [Content] = []
    var didChangeCallback: ([Content]) -> Void = { _ in }
    
    init(observeFor resource: Resource<[Content]>, callback: ([Content]) -> Void) {
        didChangeCallback = callback
        startObserving(forResource: resource)
    }
    
    func startObserving(forResource resource: Resource<[Content]>) {
        Content.observe(forResource: resource, callback: didChangeCallback)
    }
    
    func diffed(with other: ListViewModel<Content>) -> Diff<Content> {
        let change: DiffChange?
        
        if other.count > self.count {
            let insertedIndices: [Int] = other[(self.count..<other.count)].enumerated().map({ index, _ in
                return self.count + index
            })
            if insertedIndices.isEmpty {
                change = nil
            } else {
                change = .inserted(at: insertedIndices)
            }
        } else if other.count < self.count {
            let removedIndices: [Int] = self[(other.count..<self.count)].enumerated().map({ index, _ in
                return other.count + index
            })
            if removedIndices.isEmpty {
                change = nil
            } else {
                change = .removed(at: removedIndices)
            }
        } else if self.count == other.count {
            let updatedIndices: [Int] = self.enumerated().flatMap({ index, obj in
                if obj != other[index] { return index }
                return nil
            })
            if updatedIndices.isEmpty {
                change = nil
            } else {
                change = .updated(at: updatedIndices)
            }
        } else {
            fatalError("How are jokes changing other than statements above?")
        }
        
        return Diff(change: change, from: self, to: other)
    }
    
}
















/*
struct UserViewModel: ViewModel {
    
    var content: [User] = []
    var didChangeCallback: ([User]) -> Void = { _ in }

    init(changeCallback: ([User]) -> Void) {
        didChangeCallback = changeCallback
        startObserving(forResource: User.all)
    }
    
    func startObserving(forResource resource: Resource<[User]>) {
        NetworkManager.observeUsers(resource: resource, completion: { result in
            // check result and update users array
            guard let value = result.value else { return print("Error while retrieving users") }
            self.didChangeCallback(value)
        })
    }
    

}

extension UserViewModel {
    
    func diffed(with other: UserViewModel) -> Diff<UserViewModel> {
        let userChange: DiffChange?
        
        if other.count > self.count {
            let insertedIndices: [Int] = other[(self.count..<other.count)].enumerated().map({ index, _ in
                return self.count + index
            })
            if insertedIndices.isEmpty {
                userChange = nil
            } else {
                userChange = .inserted(at: insertedIndices)
            }
        } else if other.count < self.count {
            let removedIndices: [Int] = self[(other.count..<self.count)].enumerated().map({ index, _ in
                return other.count + index
            })
            if removedIndices.isEmpty {
                userChange = nil
            } else {
                userChange = .removed(at: removedIndices)
            }
        } else if self.count == other.count {
            let updatedIndices: [Int] = self.enumerated().flatMap({ index, user in
                if user != other[index] { return index }
                return nil
            })
            if updatedIndices.isEmpty {
                userChange = nil
            } else {
                userChange = .updated(at: updatedIndices)
            }
        } else {
            fatalError("How are jokes changing other than statements above?")
        }
        
        return Diff(change: userChange, from: self, to: other)
    }
    
}
*/
