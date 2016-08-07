//
//  EditViewController.swift
//  Mercury
//
//  Created by Vikramjeet Singh on 8/6/16.
//  Copyright © 2016 Vikramjeet Singh. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}

