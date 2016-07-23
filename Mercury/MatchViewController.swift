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
 - header: view that needs to be stretched
 - kTableHeaderHeight: inital header height (before stretching)
 - pageController: PageController instance
 - containerView: view that incorporated page controller
 - tableview: tableview used for scrolling
 */
private protocol StretchableHeader: class {
    associatedtype PageController
    
    var header: UIView! { get }
    var kTableHeaderHeight: CGFloat { get }
    var pageController: PageController! { get set }
    var containerView: UIView! { get }
    var tableView: UITableView! { get }
}

extension StretchableHeader where Self: UIViewController {
    /**
     This method sets the tableview's inital contentInset and contentOffset to incorporate header on top. It also removes tableview's header (set in storyboard) so that we could mange its frame otherwise tableview does it on its own
     */
    func initalizeTableView() {
        tableView.tableHeaderView = nil
        tableView.addSubview(header)
        
        tableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)
        
        updateHeader()
    }
    
    /**
     This method updates header frame according to tableview contentOffset after every scroll
     */
    func updateHeader() {
        var headerRect = CGRect(x: 0, y: -CGFloat(kTableHeaderHeight), width: self.view.frame.width, height: 300)
        if tableView.contentOffset.y < -CGFloat(kTableHeaderHeight) {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        header.frame = headerRect
    }
}

final class MatchViewController: UIViewController, StretchableHeader {
    
    @IBOutlet private weak var header: UIView!
    private let kTableHeaderHeight: CGFloat = 300
    
    private var pageController: PageController<MatchImageViewController>!
    
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            self.pageController = PageController(storyboard: self.storyboard!) { [unowned self] page in
                            self.pageControl.currentPage = page
                        }

            addChildViewController(pageController)
            pageController.view.frame = CGRect(x: 0, y: 0, width: containerView.frame.size.width, height: containerView.frame.size.height)
            containerView.addSubview(pageController.view)
            pageController.didMove(toParentViewController: self)
        }
    }
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var pageControl: UIPageControl! {
        didSet {
            pageControl.addTarget(self, action: #selector(MatchViewController.updatePage(_:)), for: .valueChanged)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initalizeTableView()
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
        return 2
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
        updateHeader()
    }
}

