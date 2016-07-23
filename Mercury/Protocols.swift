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
    var keyboardOffset: CGFloat { get }
    
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
            animationCurve = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? UInt,
            newFrame = getNewViewFrame(forKeyboardDirection: direction)
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
            newFrame.origin.y -= keyboardOffset
        }
        return newFrame
    }
}

protocol AuthorizableView: KeyboardAnimator {
    var authView: ViewType { get set }
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
}
