//
//  Inquiry.swift
//  Up
//
//  Created by David Taylor on 9/3/16.
//  Copyright © 2016 Hyper Elephant. All rights reserved.
//

import UIKit
import Firebase

class Inquiry: NSObject {
    
    var id: String
    var recipientName: String
    var upID: String
    var seen: Bool
    
    init(id: String, recipientName: String, upID:String, seen:Bool){
        
        self.id = id
        self.recipientName = recipientName
        self.upID = upID
        self.seen = seen
    }
    
    convenience init?(snapshot:FIRDataSnapshot!) {
        //print("Up snapshot", snapshot)
        var newID = ""
        var newRecipientName = ""
        var newUpID = ""
        var newSeen = false
        
        if let snapID = snapshot.key as String! {
            newID = snapID
        }else {
            return nil
        }
        
        if let snapRecipientName = snapshot.value![Constants.InquiryFields.recipientName] as! String! {
            newRecipientName = snapRecipientName
        } else {
            return nil
        }
        
        if let snapUpID = snapshot.value![Constants.InquiryFields.upID] as! String! {
            newUpID = snapUpID
        } else {
            return nil
        }
        
        if let snapSeen = snapshot.value![Constants.InquiryFields.seen] as! Bool! {
            newSeen = snapSeen
        } else {
            return nil
        }
        
        
        self.init(id: newID, recipientName: newRecipientName, upID:newUpID, seen:newSeen)
        
    }


}
