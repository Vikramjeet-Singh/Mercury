//
//  Diff.swift
//  Mercury
//
//  Created by Vikramjeet Singh on 8/14/16.
//  Copyright © 2016 Vikramjeet Singh. All rights reserved.
//

import Foundation

enum DiffChange: Equatable {
    case inserted(at: [Int])
    case removed(at: [Int])
    case updated(at: [Int])
}

struct Diff<T: Observer & Equatable> {
    
    let diffChange: DiffChange?
    let from: ListViewModel<T>
    let to: ListViewModel<T>
    
    init(change: DiffChange?, from: ListViewModel<T>, to: ListViewModel<T>) {
        self.diffChange = change
        self.from = from
        self.to = to
    }
    
    var hasDiffChanges: Bool {
        return self.diffChange != nil
    }
    
}

func ==(_ lhs: DiffChange, _ rhs: DiffChange) -> Bool {
    return false
}
