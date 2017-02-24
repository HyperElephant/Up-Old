//
//  ResponseCollectionViewCell.swift
//  Up
//
//  Created by David Taylor on 8/31/16.
//  Copyright © 2016 Hyper Elephant. All rights reserved.
//

import UIKit
import Firebase

@IBDesignable

class ResponseCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var responseTitleLabel: UILabel!
    
    var key = String()
    var ref = FIRDatabaseReference()
    var upID = String()
    
    @IBAction func okButtonPressed(_ sender: AnyObject) {
        ref = FIRDatabase.database().reference().child(Constants.ResponseFields.response)
        ref.child(key).removeValue()
        
    }
    
    override func draw(_ rect: CGRect) {
        
        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 1, y: 1, width: rect.width - 2, height: rect.height - 2))
        UIColor.white.setFill()
        ovalPath.fill()
        UpStyleKit.outlineColor.setStroke()
        ovalPath.lineWidth = 1
        ovalPath.stroke()
    }
    
}
