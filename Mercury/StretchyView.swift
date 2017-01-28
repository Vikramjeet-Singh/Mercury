//
//  StretchyView.swift
//  Mercury
//
//  Created by Vikramjeet Singh on 7/26/16.
//  Copyright © 2016 Vikramjeet Singh. All rights reserved.
//

import UIKit
import CoreGraphics

/**
 StretchyView
 - header: view that needs to be stretched
 - frame: header view's frame
 - tableview: tableview used for scrolling
 */
struct StretchyView {
    private(set) var stretchyHeader: UIView!
    private(set) var frame: CGRect!
    private(set) var tableView: UITableView!
    
    init(headerView: UIView, frame: CGRect, tableView: UITableView) {
        self.stretchyHeader = headerView
        self.frame = frame
        self.tableView = tableView
        
        self.initialize()
    }
}

extension StretchyView {
    /**
     This method sets the tableview's inital contentInset and contentOffset to incorporate header on top. It also removes tableview's header (set in storyboard) so that we could mange its frame otherwise tableview does it on its own
     */
    fileprivate func initialize() {
        tableView.tableHeaderView = nil
        tableView.addSubview(stretchyHeader)
        
        tableView.contentInset = UIEdgeInsets(top: frame.height, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -frame.height)
        
        updateView()
    }
    
    /**
     This method updates header frame according to tableview contentOffset after every scroll
     */
    func updateView() {
        var headerRect = CGRect(x: 0, y: -CGFloat(frame.height), width: frame.width, height: frame.height)
        if tableView.contentOffset.y < -CGFloat(frame.height) {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        stretchyHeader.frame = headerRect
    }
}
