//
//  CreateUpViewController.swift
//  Pods
//
//  Created by David Taylor on 7/28/16.
//
//

import UIKit
import Firebase

class CreateUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    var ref: FIRDatabaseReference!
    var friends: [FIRDataSnapshot]! = []
    var added: [Bool] = []
    private var _refHandle: FIRDatabaseHandle!
    var addedFriends: [Friend] = []
    
    @IBAction func addButtonPressed(sender: AnyObject) {
        let user = FIRAuth.auth()?.currentUser
        
        
        if ((titleTextField.text != "") && (addedFriends.count > 0)) {
            let newUp = Up(id: "", author: (user?.displayName!)!, title: titleTextField.text!, detail: descriptionTextField.text!, friends: addedFriends)
            newUp.upload()
            performSegueWithIdentifier("unwindOnUpCreation", sender: self)
        }
        else if titleTextField.text == "" {
            showAlert("Up needs title")
        }
        else if addedFriends.count == 0 {
            showAlert("Up is better with friends")
        }
        else {
            print("Error: Add checks failed")
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clearColor()
        let newFrame = CGRectMake(20, 20, self.view.frame.width - 40, self.view.frame.height - 40)
        let backgroundView = UIView(frame: newFrame)
        backgroundView.backgroundColor = UIColor.whiteColor()
        backgroundView.layer.cornerRadius = 5
        self.view.addSubview(backgroundView)
        self.view.sendSubviewToBack(backgroundView)
        
        self.friendsTableView?.dataSource = self
        self.friendsTableView?.delegate = self
        
        configureFriends()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let friend = Friend(snapshot: friends[indexPath.row])
        
        cell.textLabel!.text = friend.username
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if cell.accessoryType == .Checkmark {
                cell.accessoryType = .None
                removeFriendFromList(friends[indexPath.row])
            } else {
                cell.accessoryType = .Checkmark
                addedFriends.append(Friend(snapshot: friends[indexPath.row]))
            }
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        //let dest = segue.destinationViewController as! ViewController
        //dest.ups.append(addedUp)
    }
    
    func removeFriendFromList(unFriendData: FIRDataSnapshot){
        let unFriend = Friend(snapshot: unFriendData)
        for x in 0...(addedFriends.count - 1){
            if addedFriends[x] == unFriend{
                let cell = friendsTableView.cellForRowAtIndexPath(NSIndexPath(forItem: x, inSection: 0))
                cell!.selected = false
                addedFriends.removeAtIndex(x)
            }
        }
    }
    
    
    func configureFriends(){
        ref = FIRDatabase.database().reference()
        let username = FIRAuth.auth()?.currentUser?.displayName

        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("users").observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            if (snapshot.value![Constants.FriendFields.username] as! String!) != username {
                self.friends.append(snapshot)
                self.friendsTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.friends.count-1, inSection: 0)], withRowAnimation: .Automatic)
            }
        })
            
    }
    
    /*
    func addTestFriends(){
        var newFriend = Friend(username: "Fred")
        friends.append(newFriend)
        newFriend = Friend(username: "George")
        friends.append(newFriend)
        
    }
    */
    
    

}
