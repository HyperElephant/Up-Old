//
//  InboxCollectionViewCell.swift
//  Up
//
//  Created by David Taylor on 8/27/16.
//  Copyright © 2016 Hyper Elephant. All rights reserved.
//

import UIKit
import Firebase

class InboxCollectionViewCell: UICollectionViewCell {
    
    var sentKey = String()
    var ref = FIRDatabaseReference()
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func yesButtonPressed(sender: AnyObject) {
        ref = FIRDatabase.database().reference().child("sent")
        ref.child(sentKey).removeValue()
        print("yes")
        
    }
    @IBAction func noButtonPressed(sender: AnyObject) {
        print("no")
    }
    
}
