//
//  Protocols.swift
//  Mercury
//
//  Created by Vikramjeet Singh on 7/12/16.
//  Copyright © 2016 Vikramjeet Singh. All rights reserved.
//

import UIKit

//MARK: - KeyboardListener protocol
@objc protocol KeyboardListener {
    func keyboardWillShow(_ notification: Notification)
    func keyboardWillHide(_ notification: Notification)
}

extension KeyboardListener where Self: UIViewController {
    func registerForKeyboardNotifications() {
        // Registed for Keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(Self.keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(Self.keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unregisterFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
}

/**
 Keyboard direction.
 - up: Keyboard is coming on the screen.
 - down: Keyboard is dismissing from the screen
 */
enum KeyboardDirection {
    case up, down
}

protocol KeyboardAnimator: KeyboardListener {
    var keyboardOffset: CGFloat { get }
    var animate: (Double, UInt, CGRect) -> () { get set }
}

extension KeyboardAnimator where Self: UIViewController {
    // MARK: - Keyboard animation convenience methods
    /**
     Animates view up ro down depending upon the keyboard direction
     - Parameter notification: Keyboard notification received by the view controller
     - Parameter direction: Keyboard direction indicating if keyboard is appearing or dismissing
     */
    func animateView(_ notification: Notification, direction: KeyboardDirection) {
        if let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let animationCurve = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? UInt,
            let newFrame = getNewViewFrame(forKeyboardDirection: direction)
        {
            animate(duration, animationCurve, newFrame)
        }
    }
    
    /**
     Returns new frame for view to accomodate keyboard appearing or dismissing
     - Parameter direction: Keyboard direction indicating if keyboard is appearing or dismissing
     - Returns: New frame for the view
     */
    private func getNewViewFrame(forKeyboardDirection direction: KeyboardDirection) -> CGRect? {
        var newFrame = view.bounds
        if case KeyboardDirection.up = direction {
            if view.bounds.origin.y == 0 {
                newFrame.origin.y += keyboardOffset
            }
        } else if case KeyboardDirection.down = direction {
            if view.bounds.origin.y != 0 {
                newFrame.origin.y -= keyboardOffset
            }
        }
        return newFrame
    }
}

protocol AuthorizableView: KeyboardAnimator {
    var authView: ViewType { get }
    func configureView()
}

extension AuthorizableView {
    var buttonTitle: String {
        return authView.description
    }
    
    var canRecover: Bool {
        return authView.canRecover
    }
    
    var keyboardOffset: CGFloat {
        return authView.keyboardOffset
    }
    
    var showUsername: Bool {
        return authView.showUsername
    }
}

protocol Injectable {
    associatedtype Item
    
    func inject(_: Item)
    func assertDependencies()
}

protocol ViewModelProtocol: Collection  {
    
    associatedtype Content
    
    var count: Int { get }
    var content: [Content] { get set }
    var didChangeCallback: ([Content]) -> Void { get set }
    
    func startObserving(forResource resource: Resource<[Content]>)

    mutating func update(_ content: [Content])
}

extension ViewModelProtocol {
    
    var count: Int {
        return content.count
    }
    
    var startIndex: Int {
        return 0
    }
    
    var endIndex: Int {
        return count
    }
    
    func index(after i: Int) -> Int {
        return i + 1
    }
    
    subscript(index: Int) -> Content? {
        get {
            guard index < endIndex else { return nil }
            
            return content[index]
        }
    }
    
}

extension ViewModelProtocol {
    mutating func update(_ content: [Content]) {
        self.content = content
    }
}
