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
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController!.delegate = self
        pageViewController!.dataSource = self

        self.view.tintColor = UpStyleKit.accentColor
        //self.view.backgroundColor = UIColor.whiteColor()
        
        if let firstViewController = orderedViewControllers.first {
            pageViewController!.setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        pageViewController!.view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height);
        addChildViewController(pageViewController!)
        view.addSubview(pageViewController!.view)
        pageViewController!.didMove(toParentViewController: self)
        
        
        for subView in pageViewController!.view.subviews {
            if subView.isKind(of: UIPageControl.self) {
                print("pagecontrol")
                let pageControl = subView as! UIPageControl
                print(pageControl)
                pageControl.pageIndicatorTintColor = UpStyleKit.accentColor
                pageControl.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
                //pageViewController!.view.bringSubviewToFront(pageControl)
                self.view.bringSubview(toFront: pageControl)
            }
        }
        
        
        

        // Do any additional setup after loading the view.
    }
    
    fileprivate(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newViewController("inquiriesViewControllerID") as! InquiriesViewController,
                self.newViewController("responsesViewControllerID") as! ResponsesViewController]
    }()
    
    fileprivate func newViewController(_ ID: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "\(ID)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
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
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
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
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = pageViewController.viewControllers?.first,
            let firstViewControllerIndex = orderedViewControllers.index(of: firstViewController) else {
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
