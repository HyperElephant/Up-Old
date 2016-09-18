//
//  ViewController.swift
//  Up
//
//  Created by David Taylor on 6/25/16.
//  Copyright © 2016 Hyper Elephant. All rights reserved.
//

import UIKit
import Firebase

@IBDesignable

class UpViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    let reuseIdentifier = "upCell"
    var ups: [FIRDataSnapshot]! = []
    
    var side = CGFloat(0)
    var ref: FIRDatabaseReference!
    private var _refHandle: FIRDatabaseHandle!
    private var userEditing = false
    private var upToEdit: Up?
    var longPressGesture = UIGestureRecognizer()
    
    var tintView = UIView()
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var upCollectionView: UICollectionView!
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue){
        tintView.removeFromSuperview()
        
    }
    
    @IBAction func addButtonPressed(sender: AnyObject) {
        
        tintView = UIView(frame: self.view.frame)
        tintView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        
        self.parentViewController?.parentViewController?.view.addSubview(tintView)
        performSegueWithIdentifier("addUpSegue", sender: self)
    }
    
    @IBAction func editButtonPressed(sender: AnyObject) {
        if userEditing {
            editButton.title = "Edit"
            for cell in self.upCollectionView.visibleCells() {
                let cell = cell as! UpCollectionViewCell
                cell.stopWobble()
            }
            userEditing = false;
        }
        else {
            editButton.title = "Done"
            for cell in self.upCollectionView.visibleCells() {
                let cell = cell as! UpCollectionViewCell
                cell.wobble()
            }
            userEditing = true
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.upCollectionView?.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        self.upCollectionView?.delegate = self
        self.upCollectionView?.dataSource = self
        
        side = (self.view.frame.width / 2) - CGFloat(20)
        
        configureDatabase()
        
        let longPress = UILongPressGestureRecognizer(target:self, action: #selector(UpViewController.handleLongPress(_:)))
        longPress.minimumPressDuration = 0.1
        longPress.delaysTouchesBegan = true
        longPress.delegate = self
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(UpViewController.handleLongGesture(_:)))
        self.upCollectionView.addGestureRecognizer(longPressGesture)
        
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
        /*
        cell.layer.backgroundColor = UIColor.whiteColor().CGColor
        cell.layer.borderColor = UIColor.grayColor().CGColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = side/2
         */
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if userEditing {
            upToEdit = Up(snapshot: ups[indexPath.row])
            
            tintView = UIView(frame: self.view.frame)
            tintView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
            
            self.parentViewController?.parentViewController?.view.addSubview(tintView)
            performSegueWithIdentifier("addUpSegue", sender: self)
        }
        else {
            // handle tap events
            let up = Up(snapshot: ups[indexPath.row])
            up!.send()
            
            print("You selected cell #\(indexPath.item)!")
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {        
        return CGSizeMake(side, side);
    }
    
    func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let up = ups.removeAtIndex(sourceIndexPath.item)
        ups.insert(up, atIndex: destinationIndexPath.item)
    }
    
    
    //Helper Functions
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        let username = FIRAuth.auth()?.currentUser?.displayName
        
        // Listen for new messages in the Firebase database
        
        //On Up added to firebase
        _refHandle = self.ref.child(Constants.UpFields.ups).queryOrderedByChild(Constants.UpFields.author).queryEqualToValue(username).observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            self.ups.append(snapshot)
            self.upCollectionView.insertItemsAtIndexPaths([NSIndexPath(forRow: self.ups.count-1, inSection: 0)])
        })
        
        //On Up removed from firebase
        self.ref.child("ups").queryOrderedByChild("author").queryEqualToValue(username).observeEventType(.ChildRemoved, withBlock: { (snapshot) -> Void in
            let index = self.indexOfUp(snapshot)
            //print(index)
            self.ups.removeAtIndex(index)
            self.upCollectionView.deleteItemsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)])
        })
        
        //On Up changed in firebase
        self.ref.child("ups").queryOrderedByChild("author").queryEqualToValue(username).observeEventType(.ChildChanged, withBlock: { (snapshot) -> Void in
            let index = self.indexOfUp(snapshot)
            self.ups[index] = snapshot
            self.upCollectionView.reloadItemsAtIndexPaths([NSIndexPath(forRow: index, inSection:  0)])
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
    
    func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        
        switch(gesture.state) {
            
        case UIGestureRecognizerState.Began:
            guard let selectedIndexPath = self.upCollectionView.indexPathForItemAtPoint(gesture.locationInView(self.upCollectionView)) else {
                break
            }
            upCollectionView.beginInteractiveMovementForItemAtIndexPath(selectedIndexPath)
        case UIGestureRecognizerState.Changed:
        upCollectionView.updateInteractiveMovementTargetPosition(gesture.locationInView(gesture.view!))
        case UIGestureRecognizerState.Ended:
            upCollectionView.endInteractiveMovement()
        default:
            upCollectionView.cancelInteractiveMovement()
        }
        
        
    }
    
    func removeUpRequests(key: String){
        
        self.ref.child(Constants.InquiryFields.inquiry).queryOrderedByChild(Constants.InquiryFields.upID).queryEqualToValue(key).observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
            for item in snapshot.children {
                self.ref.child(Constants.InquiryFields.inquiry).child(item.key).removeValue()
            }
        })
        
        self.ref.child(Constants.ResponseFields.response).queryOrderedByChild(Constants.ResponseFields.upID).queryEqualToValue(key).observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
            for item in snapshot.children {
                self.ref.child(Constants.ResponseFields.response).child(item.key).removeValue()
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (upToEdit != nil) {
            let destination = segue.destinationViewController as! CreateUpViewController
            destination.upToEdit = upToEdit
        }
        upToEdit = nil
    }

}
    

