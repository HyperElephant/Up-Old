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
}
