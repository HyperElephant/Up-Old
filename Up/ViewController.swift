//
//  ViewController.swift
//  Up
//
//  Created by David Taylor on 6/25/16.
//  Copyright © 2016 Hyper Elephant. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    let reuseIdentifier = "upCell"
    var ups: [FIRDataSnapshot]! = []
    
    var side = CGFloat(0)
    var ref: FIRDatabaseReference!
    private var _refHandle: FIRDatabaseHandle!
    private var isWobbling = false;
    
    @IBOutlet weak var upCollectionView: UICollectionView!
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue){

        
    }
    
    @IBAction func editButtonPressed(sender: AnyObject) {
        if isWobbling {
            for cell in self.upCollectionView.visibleCells() {
                let cell = cell as! UpCollectionViewCell
                cell.stopWobble()
            }
            isWobbling = false;
        }
        else {
            for cell in self.upCollectionView.visibleCells() {
                let cell = cell as! UpCollectionViewCell
                cell.wobble()
            }
            isWobbling = true
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.upCollectionView?.delegate = self
        self.upCollectionView?.dataSource = self
        
        side = (self.view.frame.width / 2) - CGFloat(30)
        
        configureDatabase()
        
        let longPress = UILongPressGestureRecognizer(target:self, action: #selector(ViewController.handleLongPress(_:)))
        longPress.minimumPressDuration = 0.5
        longPress.delaysTouchesBegan = true
        longPress.delegate = self
        self.upCollectionView.addGestureRecognizer(longPress)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.ups.count
    }
    
    // make a cell for each cell index path
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UpCollectionViewCell
        let up = Up(snapshot: ups[indexPath.row])
        
        let friendString = makeFriendsString(up!.friends)

        cell.titleLabel!.text = up!.title
        cell.friendsLabel!.text = friendString

        cell.layer.backgroundColor = UIColor.whiteColor().CGColor
        cell.layer.borderColor = UIColor.grayColor().CGColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = side/2
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        let up = Up(snapshot: ups[indexPath.row])
        up!.send()
        
        print("You selected cell #\(indexPath.item)!", terminator: "")
        
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {        
        return CGSizeMake(side, side);
    }
    
    
    //Helper Functions
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        let username = FIRAuth.auth()?.currentUser?.displayName
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child(Constants.UpFields.ups).queryOrderedByChild(Constants.UpFields.author).queryEqualToValue(username).observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            self.ups.append(snapshot)
            self.upCollectionView.insertItemsAtIndexPaths([NSIndexPath(forRow: self.ups.count-1, inSection: 0)])
        })
        
        self.ref.child("ups").queryOrderedByChild("author").queryEqualToValue(username).observeEventType(.ChildRemoved, withBlock: { (snapshot) -> Void in
            let index = self.indexOfUp(snapshot)
            print(index)
            self.ups.removeAtIndex(index)
            self.upCollectionView.deleteItemsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)])
        })
    }

    
    func getFriendFromData(friends: FIRDataSnapshot) -> [Friend]{
        var newFriends = [Friend]()
        for child in friends.children{
            let username = child.name! 
            let newFriend = Friend(username: username)
            newFriends.append(newFriend)
        }
        
        return newFriends
    }
    
    func makeFriendsString(friends: [Friend]) -> String {
        var friendString = "With "
        
        if friends.count == 1 {
            friendString += friends[0].username
        } else if friends.count == 2 {
            friendString += friends[0].username
            friendString += " and "
            friendString += friends[1].username
        } else if friends.count == 0{
            friendString = ""
        }else if friends.count < 4{
            
            for x in 0...(friends.count - 1){
                friendString += friends[x].username
                if x < friends.count{
                    friendString += ", "
                } else {
                    friendString += " and "
                }
                
            }
        } else {
            for x in 0...(friends.count - 1){
                friendString += friends[x].username
                if x < friends.count{
                    friendString += ", "
                } else if x == 3{
                    friendString += " and "
                }
                
            }
            
            friendString += "and \(friends.count) others"
        }
        
        
        return friendString
    }
    
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        /*
        if gestureReconizer.state != UIGestureRecognizerState.Ended {
            return
        }
 */
        
        let p = gestureReconizer.locationInView(self.upCollectionView)
        let indexPath = self.upCollectionView.indexPathForItemAtPoint(p)
        
        if let index = indexPath {
            let cell = self.upCollectionView.cellForItemAtIndexPath(index) as! UpCollectionViewCell
            // do stuff with your cell, for example print the indexPath
            cell.wobble()
            print(index.row, terminator: "")
        } else {
            print("Could not find index path", terminator: "")
        }
    }
    
    func indexOfUp(snapshot: FIRDataSnapshot) -> Int {
        var index = 0
        for  item in self.ups {
            if (snapshot.key == item.key) {
                return index
            }
            index += 1
        }
        return -1
    }

}
    

