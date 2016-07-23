//
//  MatchImageViewController.swift
//  Mercury
//
//  Created by Vikramjeet Singh on 7/21/16.
//  Copyright © 2016 Vikramjeet Singh. All rights reserved.
//

import UIKit

protocol Pageable {
    var resourceName: String? { get }
    var pageIndex: Int { get }
    
    func setUp(content: String, pageIndex: Int)
}

final class MatchImageViewController: UIViewController, Pageable {
    
    @IBOutlet private weak var imageView: UIImageView! {
        didSet {
            if let imageName = resourceName {
                imageView.image = UIImage(named: imageName)
            }
        }
    }
    
    var resourceName: String?
    var pageIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUp(content: String, pageIndex: Int) {
        self.resourceName = content
        self.pageIndex = pageIndex
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
