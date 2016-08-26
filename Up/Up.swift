//
//  Up.swift
//  Up
//
//  Created by David Taylor on 8/23/16.
//  Copyright © 2016 Hyper Elephant. All rights reserved.
//

import UIKit
import Firebase

class Up: NSObject {
    
    var author: String
    var title: String
    var detail: String
    var friends: [Friend]

    init(author: String, title:String, detail:String, friends:[Friend]){
        //self.uid = uid
        self.author = author
        self.title = title
        self.detail = detail
        self.friends = friends
    }
    
    convenience init(snapshot:FIRDataSnapshot!) {
        //print("Snapshot", snapshot)
        let newAuthor = snapshot.value![Constants.UpFields.author] as! String!
        let newTitle = snapshot.value![Constants.UpFields.title] as! String!
        let newDetail = snapshot.value![Constants.UpFields.description] as! String!
        print(snapshot.value![Constants.UpFields.users])
        
        self.init(author: newAuthor, title:newTitle, detail:newDetail, friends:[Friend]())
        
    }
    
    func add(friend:Friend, ID:String){
        
        self.friends.append(friend)
    }
    
    func upload(){
        let ref = FIRDatabase.database().reference()
        let key = ref.child("ups").childByAutoId().key
        var users = [String: Bool]()
        for friend in friends{
            users[friend.username] = true
        }
        let newUp = ["author": self.author,
                    "title": self.title,
                    "description": self.detail,
                    "users": users]
        let update = ["/ups/\(key)": newUp]
        ref.updateChildValues(update)
        
    }

}
