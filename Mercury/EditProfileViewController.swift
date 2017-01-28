//
//  EditProfileViewController.swift
//  Mercury
//
//  Created by Vikramjeet Singh on 7/23/16.
//  Copyright © 2016 Vikramjeet Singh. All rights reserved.
//

import UIKit

final class EditProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    enum ProfileSection: Int {
        case location = 0, kids, pets, interests, logout
        
        init(at indexPath: IndexPath) {
            self.init(rawValue: indexPath.section)!
        }
        
        init(_ section: Int) {
            self.init(rawValue: section)!
        }
        
        var title: String {
            switch self {
            case .location:
                return "Location"
            case .kids:
                return "Kids"
            case .pets:
                return "Pets"
            case .interests:
                return "Interests"
            case .logout:
                return ""
            }
        }
        
        static let count = 5
    }

    @IBOutlet weak var profileImageView: RoundedImageView! {
        didSet {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EditProfileViewController.editProfileImage(_:)))
            profileImageView.addGestureRecognizer(tapGesture)
        }
    }
    
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            pageController = PageController<InfoViewController>(storyboard: self.storyboard!,
                                                                     contentList: [["hey" : "wass ur name" as NSString], ["hi" : "why should i tell u?" as NSString]], updator: { [unowned self] page in
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
            pageControl.addTarget(self, action: #selector(EditProfileViewController.updatePage(_:)), for: .valueChanged)
        }
    }
    
    private(set) var pageController: PageController<InfoViewController>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension EditProfileViewController {
    
    //Updates page according to tap on UIPageControl. One page at a time to either left or right
    func updatePage(_ pageControl: UIPageControl) {
        pageController.showController(index: pageControl.currentPage)
    }
    
    func editProfileImage(_ gesture: UITapGestureRecognizer) {
        print("Edit Profile Image pressed")
    }
    
}

extension EditProfileViewController {
    
    @objc(numberOfSectionsInTableView:)
    func numberOfSections(in tableView: UITableView) -> Int {
        return ProfileSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if case .logout = ProfileSection(section) {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = ProfileSection(section)
        if case .logout = section { return nil }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileHeaderCell.reusableIdentifier) as! ProfileHeaderCell
        cell.configure(title: section.title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = ProfileSection(section)
        if case .logout = section { return 0 }
        return 45
    }
    
    @objc(tableView:cellForRowAtIndexPath:)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = ProfileSection(at: indexPath)
        switch section {
        case .location: fallthrough
        case .kids: fallthrough
        case .pets: fallthrough
        case .interests:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileRowCell.reusableIdentifier) as! ProfileRowCell
                cell.configure("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.")
            return cell
        case .logout:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileActionCell.reusableIdentifier) as! ProfileActionCell
                cell.configure(type: ProfileActionCell.ActionType(at: indexPath.row))
            return cell
        }
        
    }
    
}
