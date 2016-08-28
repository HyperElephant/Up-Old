//
//  InboxCollectionViewCell.swift
//  Up
//
//  Created by David Taylor on 8/27/16.
//  Copyright © 2016 Hyper Elephant. All rights reserved.
//

import UIKit

class InboxCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func yesButtonPressed(sender: AnyObject) {
        print("yes")
    }
    @IBAction func noButtonPressed(sender: AnyObject) {
        print("no")
    }
    
}
