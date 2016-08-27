//
//  Friend.swift
//  Up
//
//  Created by David Taylor on 8/24/16.
//  Copyright © 2016 Hyper Elephant. All rights reserved.
//

import UIKit
import Firebase

class Friend: NSObject {
    
    var username: String

    init(username:String){
        self.username = username
    }
    
    convenience init(snapshot:FIRDataSnapshot!) {
        //print("Snapshot", snapshot)
        let newUsername = snapshot.value![Constants.FriendFields.username] as! String!
        
        self.init(username: newUsername)
        
    }
}
