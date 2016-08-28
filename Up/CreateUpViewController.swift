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
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        
        let user = FIRAuth.auth()?.currentUser
        
        let newUp = Up(id: "", author: (user?.email!)!, title: titleTextField.text!, detail: descriptionTextField.text!, friends: addedFriends)
        newUp.upload()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        for x in 0...addedFriends.count{
            if addedFriends[x] == unFriend{
                addedFriends.removeAtIndex(x)
            }
        }
    }
    
    func configureFriends(){
        ref = FIRDatabase.database().reference()
        print("here")
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("users").observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            print("there")
            self.friends.append(snapshot)
            self.friendsTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.friends.count-1, inSection: 0)], withRowAnimation: .Automatic)})
        
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
