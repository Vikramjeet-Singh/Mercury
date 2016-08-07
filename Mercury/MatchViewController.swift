//
//  MatchViewController.swift
//  Mercury
//
//  Created by Vikramjeet Singh on 7/18/16.
//  Copyright © 2016 Vikramjeet Singh. All rights reserved.
//

import UIKit

/**
 Protocol for stretchy headers
 - stretchyView: Stretchyview instance
 - pageController: PageController instance
 */
protocol StretchableHeader {
    associatedtype PageableController: UIViewController, Pageable
    
    var stretchyView: StretchyView { get }
    var pageController: PageController<PageableController>! { get }
}


final class MatchViewController: UIViewController, StretchableHeader {
    
    @IBOutlet private weak var header: UIView!
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            self.pageController = PageController<MatchImageViewController>(storyboard: self.storyboard!,
                                                                           contentList: ["Logo.png", "Cat_1.png", "Cat_2.png", "Logo.png", "Cat_1.png"],
                                                                           updator: { [unowned self] page in
                                                                                            self.pageControl.currentPage = page
                                                                            })
            
            addChildViewController(pageController)
            pageController.view.frame = CGRect(x: 0, y: 0, width: containerView.frame.size.width, height: containerView.frame.size.height)
            containerView.addSubview(pageController.view)
            pageController.didMove(toParentViewController: self)
        }
    }
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 100
        }
    }
    
    @IBOutlet private weak var pageControl: UIPageControl! {
        didSet {
            pageControl.addTarget(self, action: #selector(MatchViewController.updatePage(_:)), for: .valueChanged)
        }
    }
    
    private var headerFrame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0) {
        didSet {
            tableView.tableHeaderView?.frame = self.headerFrame
        }
    }

    private(set) lazy var stretchyView: StretchyView = {
        return StretchyView(headerView: self.header,
                            frame: self.headerFrame,
                            tableView: self.tableView)
    }()
    
    private(set) var pageController: PageController<MatchImageViewController>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up nav bar
        navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.headerFrame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.height * 0.50)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Updates page according to tap on UIPageControl. One page at a time to either left or right
    func updatePage(_ pageControl: UIPageControl) {
        pageController.showController(index: pageControl.currentPage)
    }
}

extension MatchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: InfoCell.reusableIdentifier, for: indexPath) as! InfoCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: InterestsCell.reusableIdentifier, for: indexPath) as! InterestsCell
        }
        return cell
    }
}

extension MatchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        stretchyView.updateView()
    }
}

