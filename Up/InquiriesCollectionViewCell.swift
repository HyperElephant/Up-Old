//
//  InboxCollectionViewCell.swift
//  Up
//
//  Created by David Taylor on 8/27/16.
//  Copyright © 2016 Hyper Elephant. All rights reserved.
//

import UIKit
import Firebase

class InquiriesCollectionViewCell: UICollectionViewCell {
    
    var key = String()
    var ref = FIRDatabaseReference()
    var upID = String()
    var upAuthor = String()
    var username = String()
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func yesButtonPressed(sender: AnyObject) {
        ref = FIRDatabase.database().reference().child("inquiry")
        ref.child(key).removeValue()
        sendResponse(true)
        
    }
    @IBAction func noButtonPressed(sender: AnyObject) {
        ref = FIRDatabase.database().reference().child("inquiry")
        ref.child(key).removeValue()
        sendResponse(false)
    }
    
    func sendResponse(isUp: Bool){
        let ref = FIRDatabase.database().reference()
        let key = ref.child(Constants.ResponseFields.response).childByAutoId().key
        let newResponse = [Constants.ResponseFields.isUp: isUp,
                       Constants.ResponseFields.upID: self.upID,
                       Constants.ResponseFields.seen: false,
                       Constants.ResponseFields.authorName: self.upAuthor,
                       Constants.ResponseFields.responderName: self.username]
        let update = ["/response/\(key)": newResponse]
        ref.updateChildValues(update)
    }
    
}
