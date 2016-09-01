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
    
    var id: String
    var author: String
    var title: String
    var detail: String
    var friends: [Friend]

    init(id: String, author: String, title:String, detail:String, friends:[Friend]){
        self.id = id
        self.author = author
        self.title = title
        self.detail = detail
        self.friends = friends
    }
    
    convenience init?(snapshot:FIRDataSnapshot!) {
        //print("Up snapshot", snapshot)
        var newID = ""
        var newAuthor = ""
        var newTitle = ""
        var newDetail = ""
        var newFriends = [Friend]()
        
        if let snapID = snapshot.key as String! {
            newID = snapID
        }else {
            return nil
        }
        
        if let snapAuthor = snapshot.value![Constants.UpFields.author] as! String! {
            newAuthor = snapAuthor
        } else {
            return nil
        }
        
        if let snapTitle = snapshot.value![Constants.UpFields.title] as! String! {
            newTitle = snapTitle
        } else {
            return nil
        }
        
        if let snapDetail = snapshot.value![Constants.UpFields.description] as! String! {
            newDetail = snapDetail
        } else {
            return nil
        }

        if let newFriendsData = snapshot.value![Constants.UpFields.users] as! [String:Bool]! {
        
            for (key, _) in newFriendsData{
                newFriends.append(Friend(username: key))
            }
            
        }
        
        self.init(id: newID, author: newAuthor, title:newTitle, detail:newDetail, friends: newFriends)
        
    }
    
    func add(friend:Friend, ID:String){
        
        self.friends.append(friend)
    }
    
    func upload(){
        let ref = FIRDatabase.database().reference()
        let key = ref.child("ups").childByAutoId().key
        self.id = key
        var users = [String: Bool]()
        for friend in friends{
            users[friend.username] = true
        }
        let newUp = [Constants.UpFields.author: self.author,
                    Constants.UpFields.title: self.title,
                    Constants.UpFields.description: self.detail,
                    Constants.UpFields.users: users]
        let update = ["/ups/\(key)": newUp]
        ref.updateChildValues(update)
    }
    
    func send(){
        let ref = FIRDatabase.database().reference()
        
        for friend in friends {
            let key = ref.child("inquiry").childByAutoId().key
            let newSent = [Constants.InquiryFields.recipientName: friend.username,
                           Constants.InquiryFields.upID: self.id]
            let update = ["/inquiry/\(key)": newSent]
            ref.updateChildValues(update)
        
        }
        
        
    }
    
    

}
