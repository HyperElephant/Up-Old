//
//  Response.swift
//  Up
//
//  Created by David Taylor on 9/3/16.
//  Copyright © 2016 Hyper Elephant. All rights reserved.
//

import UIKit
import Firebase

class Response: NSObject {
    
    var id: String
    var authorName: String
    var responderName: String
    var upID: String
    var seen: Bool
    var isUp: Bool
    
    init(id: String, authorName: String, responderName: String, upID:String, seen:Bool, isUp: Bool){
        
        self.id = id
        self.authorName = authorName
        self.responderName = responderName
        self.upID = upID
        self.seen = seen
        self.isUp = isUp
    }
    
    convenience init?(snapshot:FIRDataSnapshot!) {
        //print("Up snapshot", snapshot)
        var newID = ""
        var newAuthorName = ""
        var newResponderName = ""
        var newUpID = ""
        var newSeen = false
        var newIsUp = false
        
        if let snapID = snapshot.key as String! {
            newID = snapID
        }else {
            return nil
        }
        
        if let snapAuthorName = (snapshot.value as! NSDictionary?)?[Constants.ResponseFields.authorName] as! String! {
            newAuthorName = snapAuthorName
        } else {
            return nil
        }
        
        if let snapResponderName = (snapshot.value as! NSDictionary?)?[Constants.ResponseFields.responderName] as! String! {
            newResponderName = snapResponderName
        } else {
            return nil
        }
        
        if let snapUpID = (snapshot.value as! NSDictionary?)?[Constants.ResponseFields.upID] as! String! {
            newUpID = snapUpID
        } else {
            return nil
        }
        
        if let snapSeen = (snapshot.value as! NSDictionary?)?[Constants.ResponseFields.seen] as! Bool! {
            newSeen = snapSeen
        } else {
            return nil
        }
        
        if let snapIsUp = (snapshot.value as! NSDictionary?)?[Constants.ResponseFields.isUp] as! Bool! {
            newIsUp = snapIsUp
        } else {
            return nil
        }
        
        
        self.init(id: newID, authorName: newAuthorName, responderName: newResponderName, upID:newUpID, seen:newSeen, isUp: newIsUp)
        
    }


}
