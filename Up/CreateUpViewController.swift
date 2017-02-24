//
//  CreateUpViewController.swift
//  Pods
//
//  Created by David Taylor on 7/28/16.
//
//

import UIKit
import Firebase

class CreateUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var friendsSearchBar: UISearchBar!
    
    var ref: FIRDatabaseReference!
    var friends: [FIRDataSnapshot]! = []
    var added: [Bool] = []
    fileprivate var _refHandle: FIRDatabaseHandle!
    var addedFriends: [Friend] = []
    var upToEdit: Up?
    
    var filtered = [FIRDataSnapshot]()
    var searchActive : Bool = false
    
    
    @IBAction func addButtonPressed(_ sender: AnyObject) {
        let user = FIRAuth.auth()?.currentUser
        
        
        if ((titleTextField.text != "") && (addedFriends.count > 0)) {
            
            if (upToEdit == nil) {
                let newUp = Up(id: "", author: (user?.displayName!)!, title: titleTextField.text!, detail: descriptionTextField.text!, friends: addedFriends)
                newUp.upload()
                performSegue(withIdentifier: "unwindOnUpCreation", sender: self)
            } else {
                upToEdit!.title = titleTextField.text!
                upToEdit!.detail = descriptionTextField.text!
                upToEdit!.friends = addedFriends
                upToEdit!.edit()
                performSegue(withIdentifier: "unwindOnUpCreation", sender: self)
            }
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
        upToEdit = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.tintColor = UpStyleKit.accentColor
        
        self.view.backgroundColor = .clear
        let newFrame = CGRect(x: 20, y: 20, width: self.view.frame.width - 40, height: self.view.frame.height - 40)
        let backgroundView = UIView(frame: newFrame)
        backgroundView.backgroundColor = UIColor.white
        backgroundView.layer.cornerRadius = 5
        self.view.addSubview(backgroundView)
        self.view.sendSubview(toBack: backgroundView)
        
        self.friendsTableView?.dataSource = self
        self.friendsTableView?.delegate = self
        friendsTableView.tableFooterView = UIView(frame: CGRect.zero)

        friendsSearchBar.delegate = self
        
        configureFriends()
        
        // Do any additional setup after loading the view.
        
        if upToEdit != nil {
            titleTextField.text = upToEdit!.title
            descriptionTextField.text = upToEdit!.detail
            for friend in upToEdit!.friends {
                addedFriends.append(friend)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Mark: TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return friends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var friendName = ""
        if(searchActive){
            let friend = Friend(snapshot: filtered[indexPath.row])
            friendName = friend.username
        } else {
            let friend = Friend(snapshot: friends[indexPath.row])
            friendName = friend.username
        }
        
         for friend in addedFriends {
            if friend.username  == friendName{
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        
        cell.textLabel!.text = friendName

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                removeFriendFromList(friends[indexPath.row])
            } else {
                cell.accessoryType = .checkmark
                addedFriends.append(Friend(username: friends[indexPath.row]))
            }
        }
    }
    
    
    //Mark: Searchbar
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = friends.filter({ (snapshot) -> Bool in
            let tmp: NSString = Friend(snapshot: snapshot).username as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.friendsTableView.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        //let dest = segue.destinationViewController as! ViewController
        //dest.ups.append(addedUp)
    }
    
    func removeFriendFromList(_ unFriendData: FIRDataSnapshot){
        let unFriend = Friend(snapshot: unFriendData)
        for x in 0...(addedFriends.count - 1){
            if addedFriends[x].username == unFriend.username{
                let cell = friendsTableView.cellForRow(at: IndexPath(item: x, section: 0))
                cell!.isSelected = false
                addedFriends.remove(at: x)
            }
        }
    }
    
    
    func configureFriends(){
        ref = FIRDatabase.database().reference()
        let username = FIRAuth.auth()?.currentUser?.displayName

        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("users").observe(.childAdded, with: { (snapshot) -> Void in
            if ((snapshot.value as? NSDictionary)?[Constants.FriendFields.username] as! String!) != username {
                self.friends.append(snapshot)
                self.friendsTableView.insertRows(at: [IndexPath(row: self.friends.count-1, section: 0)], with: .automatic)
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
