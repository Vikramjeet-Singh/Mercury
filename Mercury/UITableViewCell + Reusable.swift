//
//  UITableViewCell + Reusable.swift
//  Mercury
//
//  Created by Vikramjeet Singh on 7/18/16.
//  Copyright © 2016 Vikramjeet Singh. All rights reserved.
//

import UIKit

/**
 ReusableView protocol makes sure that conforming UITableViewCell has resuseIdentifier as string of its type.
 It helps in less stringified code
 */
protocol ReusableView {}

extension ReusableView {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView {}
extension UICollectionViewCell: ReusableView {}

/**
 Segueable protocol makes sure that conforming UIViewController has segueIdentifier as string of its type.
 It helps in less stringified code
 */
protocol Segueable {}

extension Segueable where Self: UIViewController {
    static var segueIdentifier: String {
        return String(describing: self)
    }
}

extension UIViewController: Segueable {}

/**
 StoryboardIdentifiable protocol makes sure that conforming UIViewController has storyboardIdentifier as string of its type.
 It helps in less stringified code
 */protocol StoryboardIdentifiable {}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension UIViewController: StoryboardIdentifiable {}
