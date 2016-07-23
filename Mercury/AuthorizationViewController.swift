//
//  LoginViewController.swift
//  Mercury
//
//  Created by Vikramjeet Singh on 7/11/16.
//  Copyright © 2016 Vikramjeet Singh. All rights reserved.
//

import UIKit

enum ViewType {
    case signUp, logIn
}

extension ViewType: CustomStringConvertible {
    var description: String {
        switch self {
        case .signUp: return "Sign Up"
        case .logIn: return "Log In"
        }
    }
    
    var keyboardOffset: CGFloat {
        switch self {
        case .signUp: return 50.0
        case .logIn: return 100.0
        }
    }
    
    var canRecover: Bool {
        switch self {
        case .signUp: return false
        case .logIn: return true
        }
    }
}

final class AuthorizationViewController: UIViewController, AuthorizableView {
    var authView: ViewType = .logIn
    var keyboardOffset: CGFloat = 0.0
    
    //Animate view to adjust to keyboard
    lazy var animate: (Double, UInt, CGRect) -> () = {
        duration, animationCurve, newFrame in
        UIView.animate(withDuration: duration,
        delay: 0.05,
        options: UIViewAnimationOptions(rawValue: animationCurve << 16),
        animations: {
            self.view.bounds = newFrame
        })
    }
    
    @IBOutlet weak private var logIn: UIButton!
    @IBOutlet weak private var recover: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add gesture recognizer for dismissing keyboard
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(AuthorizationViewController.dismissKeyboard)))
        
        // Set up authorization view
        logIn.setTitle(buttonTitle, for: .normal)
        recover.isHidden = !canRecover
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Register for Keyboard notifications
        self.registerForKeyboardNotifications()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Unregister for Keyboard notifications
        self.unregisterFromKeyboardNotifications()
    }
}

extension AuthorizationViewController {
    // MARK: KeyboardListener methods
    func keyboardWillShow(_ notification: Notification) {
        animateView(notification, direction: .up)
    }
    
    func keyboardWillHide(_ notification: Notification) {
        animateView(notification, direction: .down)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

