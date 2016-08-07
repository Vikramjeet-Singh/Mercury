//
//  InfoViewController.swift
//  Mercury
//
//  Created by Vikramjeet Singh on 8/6/16.
//  Copyright © 2016 Vikramjeet Singh. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController, Pageable {
    
    var content: [String : AnyObject]?
    
    var pageIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUp(content: [String : AnyObject], pageIndex: Int) {
        self.content = content
        self.pageIndex = pageIndex
    }
}
