//
//  Helpers.swift
//  Up
//
//  Created by David Taylor on 8/25/16.
//  Copyright © 2016 Hyper Elephant. All rights reserved.
//

import UIKit

extension UIViewController{
    
    func showAlert(message: String){
        let alertController = UIAlertController(title: "Oh, no!", message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showAlertWithOK(message: String){
        let alertController = UIAlertController(title: "Oh, no!", message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            return true
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            return false
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

