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
        
        if let snapshotValue = snapshot.value as? NSDictionary{
            if let snapAuthor = snapshotValue[Constants.UpFields.author] as? String{
                newAuthor = snapAuthor
            }
            if let snapTitle = snapshotValue[Constants.UpFields.title] as? String{
                newTitle = snapTitle
            }
            if let snapDetail = snapshotValue[Constants.UpFields.description] as? String{
                newDetail = snapDetail
            }
            if let snapFriendsData = snapshotValue[Constants.UpFields.users] as? [String:Bool]{
                for (key, _) in snapFriendsData{
                    newFriends.append(Friend(username: key))
                }
            }
        }
        
        if let snapID = snapshot.key as String! {
            newID = snapID
        }else {
            return nil
        }

        self.init(id: newID, author: newAuthor, title:newTitle, detail:newDetail, friends: newFriends)
        
    }
    
    func add(_ friend:Friend, ID:String){
        
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
                    Constants.UpFields.users: users] as [String : Any]
        let update = ["/ups/\(key)": newUp]
        ref.updateChildValues(update)
    }
    
    func edit(){
        let key = self.id
        let ref = FIRDatabase.database().reference().child("ups")
        var users = [String: Bool]()
        for friend in friends{
            users[friend.username] = true
        }
        let editedUp = [Constants.UpFields.author: self.author,
                     Constants.UpFields.title: self.title,
                     Constants.UpFields.description: self.detail,
                     Constants.UpFields.users: users] as [String : Any]
        let update = ["/\(key)": editedUp]
        ref.updateChildValues(update)
    }
    
    func send(){
        let ref = FIRDatabase.database().reference()
        
        for friend in friends {
            let key = ref.child(Constants.InquiryFields.inquiry).childByAutoId().key
            let newSent = [Constants.InquiryFields.recipientName: friend.username,
                           Constants.InquiryFields.upID: self.id,
                           Constants.InquiryFields.seen: false] as [String : Any]
            let update = ["/inquiry/\(key)": newSent]
            ref.updateChildValues(update)
        
        }
        
        
    }
    
    

}
