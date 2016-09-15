//
//  ReguestsPageViewController.swift
//  Up
//
//  Created by David Taylor on 8/31/16.
//  Copyright © 2016 Hyper Elephant. All rights reserved.
//

import UIKit

class RequestsPageViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    @IBOutlet weak var requestsNavigationBar: UINavigationItem!
    var pageViewController : UIPageViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        pageViewController!.delegate = self
        pageViewController!.dataSource = self

        self.view.tintColor = UpStyleKit.accentColor
        //self.view.backgroundColor = UIColor.whiteColor()
        
        if let firstViewController = orderedViewControllers.first {
            pageViewController!.setViewControllers([firstViewController],
                               direction: .Forward,
                               animated: true,
                               completion: nil)
        }
        
        pageViewController!.view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
        addChildViewController(pageViewController!)
        view.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)
        
        
        for subView in pageViewController!.view.subviews {
            if subView.isKindOfClass(UIPageControl) {
                print("pagecontrol")
                let pageControl = subView as! UIPageControl
                print(pageControl)
                pageControl.pageIndicatorTintColor = UpStyleKit.accentColor
                pageControl.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
                //pageViewController!.view.bringSubviewToFront(pageControl)
                self.view.bringSubviewToFront(pageControl)
            }
        }
        
        
        

        // Do any additional setup after loading the view.
    }
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newViewController("inquiriesViewControllerID") as! InquiriesViewController,
                self.newViewController("responsesViewControllerID") as! ResponsesViewController]
    }()
    
    private func newViewController(ID: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewControllerWithIdentifier("\(ID)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = pageViewController.viewControllers?.first,
            firstViewControllerIndex = orderedViewControllers.indexOf(firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
