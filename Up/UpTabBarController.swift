//
//  UpTabBarController.swift
//  Up
//
//  Created by David Taylor on 9/7/16.
//  Copyright © 2016 Hyper Elephant. All rights reserved.
//

import UIKit

class UpTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.view.tintColor = UpStyleKit.accentColor
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
