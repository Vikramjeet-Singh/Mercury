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
        case .logIn: return 50.0
        }
    }
    
    var canRecover: Bool {
        switch self {
        case .signUp: return false
        case .logIn: return true
        }
    }
    
    var showUsername: Bool {
        switch self {
        case .signUp: return true
        case .logIn: return false
        }
    }
}

final class AuthorizationViewController: UIViewController, AuthorizableView {
    private(set) var authView: ViewType = .logIn
    fileprivate var dismissCallback: () -> Void = { _ in }
    
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
    
    @IBOutlet fileprivate weak var logo: RoundedImageView!
    
    @IBOutlet fileprivate weak var username: UITextField!
    @IBOutlet fileprivate weak var password: UITextField!
    @IBOutlet fileprivate weak var email: UITextField!

    @IBOutlet weak private var logIn: UIButton!
    @IBOutlet weak private var recover: UIButton!
    
    static func create(viewType: ViewType, dismissCallback: @escaping () -> Void) -> AuthorizationViewController {
        let authVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: AuthorizationViewController.storyboardIdentifier) as! AuthorizationViewController
        authVC.authView = viewType
        authVC.dismissCallback = dismissCallback
        return authVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add gesture recognizer for dismissing keyboard
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(AuthorizationViewController.dismissKeyboard)))
        
        // Set up authorization view
        configureView()
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
    
    @IBAction func authenticate(_ sender: UIButton) {
        switch authView {
        case .logIn:
            logIn(sender)
        case .signUp:
            signUp(sender)
        }
    }
    
    func configureView() {
        logIn.setTitle(buttonTitle, for: .normal)
        recover.isHidden = !canRecover
        username.isHidden = !showUsername
    }
}

extension AuthorizationViewController {
    fileprivate func logIn(_ sender: UIButton) {
        dismissKeyboard()
        
        guard let email = self.email.text,
            let password = self.password.text else { return }
        
        do {
            try User.signIn(email: email,
                            password: password,
                            completion: { userResult in
                                // guard let user = userResult.value.flatMap({$0})
                                guard let error = userResult.error else {
                                    return self.dismissCallback()
                                }
                                print("Error during authorization : \(error)")
                            })
        } catch {
            print("Error during user creation : \(error)")
        }
    }
    
    fileprivate func signUp(_ sender: UIButton) {
        dismissKeyboard()
        
        guard let email = self.email.text,
            let username = self.username.text,
            let password = self.password.text else { return }
        
        do {
            try User.createUser(email: email,
                                password: password,
                                username: username,
                                completion: { userResult in
                                    // guard let user = userResult.value.flatMap({$0})
                                    guard let error = userResult.error else {
                                        return self.dismissCallback()
                                    }
                                    print("Error during authorization : \(error)")
                            })
        } catch {
            print("Error during user creation : \(error)")
        }
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

