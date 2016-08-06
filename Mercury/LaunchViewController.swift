//
//  ViewController.swift
//  Mercury
//
//  Created by Vikramjeet Singh on 7/11/16.
//  Copyright © 2016 Vikramjeet Singh. All rights reserved.
//

import UIKit
import Firebase

final class LaunchViewController: UIViewController {
    @IBOutlet weak var logo: RoundedImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true

        // If already authenticated
        if CurrentUser.uid != nil {
            self.pushMatchViewController()
            return
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(_ sender: UIButton) {
        let loginVC = AuthorizationViewController.create(viewType: .logIn, dismissCallback: {
            self.dismiss(animated: false, completion: { [weak self] in
                self?.pushMatchViewController()
            })
        })
        self.present(loginVC, animated: true, completion: nil)
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        let signUpVC = AuthorizationViewController.create(viewType: .signUp, dismissCallback: {
            self.dismiss(animated: false, completion: { [weak self] in
                self?.pushMatchViewController()
            })
        })
        self.present(signUpVC, animated: true, completion: nil)
    }
    
    private func pushMatchViewController() {
        performSegue(withIdentifier: MatchViewController.segueIdentifier, sender: self)
    }
}
