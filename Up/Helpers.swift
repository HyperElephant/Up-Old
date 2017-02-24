//
//  Helpers.swift
//  Up
//
//  Created by David Taylor on 8/25/16.
//  Copyright © 2016 Hyper Elephant. All rights reserved.
//

import UIKit

extension UIViewController{
    
    func showAlert(_ message: String){
        let alertController = UIAlertController(title: "Oh, no!", message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertWithOK(_ message: String){
        let alertController = UIAlertController(title: "Oh, no!", message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            return true
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            return false
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

