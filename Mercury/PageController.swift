//
//  PageController.swift
//  Mercury
//
//  Created by Vikramjeet Singh on 7/22/16.
//  Copyright © 2016 Vikramjeet Singh. All rights reserved.
//

import UIKit

/**
 Generic PageController class that takes any view controller to be shown in UIPageViewController
 */
final class PageController<T where T: UIViewController, T: StoryboardIdentifiable, T: Pageable>: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate  {
    
    var contentControllers: [T] = []
    var pageUpdator: (Int) -> () = {_ in }
    
    private var mainStoryboard: UIStoryboard?
    private var currentPage = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("This controller should not be initialized from storyoard. Otherwise it should call initalize method")
    }
    
    init(storyboard: UIStoryboard, transitionStyle style: UIPageViewControllerTransitionStyle = .scroll, navigationOrientation: UIPageViewControllerNavigationOrientation = .horizontal, options: [String : AnyObject]? = [:], updator: (Int) -> Void) {
        mainStoryboard = storyboard
        pageUpdator = updator
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation)
        self.initialize()
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! MatchImageViewController).pageIndex
        if index <= 0 { return nil }
        index -= 1
        return self.viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! MatchImageViewController).pageIndex
        index += 1
        if index >= 5 { return nil }
        return self.viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else { return }
        if let topViewController = pageViewController.viewControllers?.first as? MatchImageViewController {
            self.pageUpdator(topViewController.pageIndex)
        }
    }
    
    func showController(index: Int, animated: Bool = true, completion: ((Bool) -> Swift.Void)? = nil) {
        if let viewController = viewControllerAtIndex(index: index) {
            let direction: UIPageViewControllerNavigationDirection = currentPage > index ? .reverse : .forward
            self.setViewControllers([viewController], direction: direction, animated: true, completion: nil)
        }
    }
}

private extension PageController {
    private func initialize() {
        self.delegate = self
        self.dataSource = self
        
        //set initial view controller in page controller
        let initalContentViewController = self.mainStoryboard?.instantiateViewController(withIdentifier: T.storyboardIdentifier) as! T
        initalContentViewController.setUp(content: "Logo.png", pageIndex: 0)
        contentControllers.append(initalContentViewController)
        self.setViewControllers([initalContentViewController], direction: .forward, animated: true, completion: nil)
    }
    
    private func viewControllerAtIndex(index : Int) -> T? {
        if((5 == 0) || (index >= 5)) {
            return nil
        }
        // update previous page
        currentPage = index
        
        // reuse already created view controllers
        if index < contentControllers.count {
            return contentControllers[index]
        }
        
        let pageContentViewController = self.mainStoryboard?.instantiateViewController(withIdentifier: T.storyboardIdentifier) as! T
        
        //TODO: Need to be changed
        if index % 2 == 0 {
            pageContentViewController.setUp(content: "Logo.png", pageIndex: index)
        } else {
            pageContentViewController.setUp(content: "Cat_1.png", pageIndex: index)
        }
        contentControllers.append(pageContentViewController)
        return pageContentViewController
    }
}
