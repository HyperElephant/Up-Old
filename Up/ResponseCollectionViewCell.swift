//
//  ResponseCollectionViewCell.swift
//  Up
//
//  Created by David Taylor on 8/31/16.
//  Copyright © 2016 Hyper Elephant. All rights reserved.
//

import UIKit
import Firebase

class ResponseCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var responseTitleLabel: UILabel!
    
    var key = String()
    var ref = FIRDatabaseReference()
    var upID = String()
    
    @IBAction func okButtonPressed(sender: AnyObject) {
        ref = FIRDatabase.database().reference().child(Constants.ResponseFields.response)
        ref.child(key).removeValue()
        
    }
    
}
