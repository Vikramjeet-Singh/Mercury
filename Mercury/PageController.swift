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
final class PageController<T>: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate where T: UIViewController, T: StoryboardIdentifiable, T: Pageable  {
    
    fileprivate var contentList: [T.Content] = []
    fileprivate var contentControllers: [T] = []
    
    var pageUpdator: (Int) -> () = {_ in }
    
    fileprivate var mainStoryboard: UIStoryboard?
    fileprivate var currentPage = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("This controller should not be initialized from storyoard. Otherwise it should call initalize method")
    }
    
    init(storyboard: UIStoryboard, contentList: [T.Content], transitionStyle style: UIPageViewControllerTransitionStyle = .scroll, navigationOrientation: UIPageViewControllerNavigationOrientation = .horizontal, options: [String : AnyObject]? = [:], updator: @escaping (Int) -> Void) {
        self.mainStoryboard = storyboard
        self.pageUpdator = updator
        self.contentList = contentList
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation)
        self.initialize()
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! T).pageIndex
        if index <= 0 { return nil }
        index -= 1
        return self.viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! T).pageIndex
        index += 1
        if index > contentList.count { return nil }
        return self.viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else { return }
        if let topViewController = pageViewController.viewControllers?.first as? T {
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

extension PageController {
    fileprivate func initialize() {
        self.delegate = self
        self.dataSource = self
        
        //set initial view controller in page controller
        let initalContentViewController = self.mainStoryboard?.instantiateViewController(withIdentifier: T.storyboardIdentifier) as! T
        initalContentViewController.setUp(content: contentList[0], pageIndex: 0)
        contentControllers.append(initalContentViewController)
        self.setViewControllers([initalContentViewController], direction: .forward, animated: true, completion: nil)
    }
    
    fileprivate func viewControllerAtIndex(index : Int) -> T? {
        if((contentList.count == 0) || (index >= contentList.count)) {
            return nil
        }
        // update previous page
        currentPage = index
        
        // reuse already created view controllers
        if index < contentControllers.count {
            return contentControllers[index]
        }
        
        let pageContentViewController = self.mainStoryboard?.instantiateViewController(withIdentifier: T.storyboardIdentifier) as! T
        
        pageContentViewController.setUp(content: contentList[index], pageIndex: index)

        contentControllers.append(pageContentViewController)
        return pageContentViewController
    }
}
