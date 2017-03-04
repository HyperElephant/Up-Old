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
    fileprivate var _refHandle: FIRDatabaseHandle!
    fileprivate var userEditing = false
    fileprivate var upToEdit: Up?
    var longPressGesture = UIGestureRecognizer()
    
    var tintView = UIView()
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var upCollectionView: UICollectionView!
    
    @IBAction func myUnwindAction(_ unwindSegue: UIStoryboardSegue){
        tintView.removeFromSuperview()
        
    }
    
    @IBAction func addButtonPressed(_ sender: AnyObject) {
        
        tintView = UIView(frame: self.view.frame)
        tintView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        self.parent?.parent?.view.addSubview(tintView)
        performSegue(withIdentifier: "addUpSegue", sender: self)
    }
    
    @IBAction func editButtonPressed(_ sender: AnyObject) {
        if userEditing {
            editButton.title = "Edit"
            for cell in self.upCollectionView.visibleCells {
                let cell = cell as! UpCollectionViewCell
                cell.stopWobble()
            }
            userEditing = false;
        }
        else {
            editButton.title = "Done"
            for cell in self.upCollectionView.visibleCells {
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.ups.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UpCollectionViewCell
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if userEditing {
            upToEdit = Up(snapshot: ups[indexPath.row])
            
            tintView = UIView(frame: self.view.frame)
            tintView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            
            self.parent?.parent?.view.addSubview(tintView)
            performSegue(withIdentifier: "addUpSegue", sender: self)
        }
        else {
            // handle tap events
            let up = Up(snapshot: ups[indexPath.row])
            up!.send()
            
            print("You selected cell #\(indexPath.item)!")
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {        
        return CGSize(width: side, height: side);
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let up = ups.remove(at: sourceIndexPath.item)
        ups.insert(up, at: destinationIndexPath.item)
    }
    
    
    //Helper Functions
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        let username = FIRAuth.auth()?.currentUser?.displayName
        
        // Listen for new messages in the Firebase database
        
        //On Up added to firebase
        _refHandle = self.ref.child(Constants.UpFields.ups).queryOrdered(byChild: Constants.UpFields.author).queryEqual(toValue: username).observe(.childAdded, with: { (snapshot) -> Void in
            self.ups.append(snapshot)
            self.upCollectionView.insertItems(at: [IndexPath(row: self.ups.count-1, section: 0)])
        })
        
        //On Up removed from firebase
        self.ref.child("ups").queryOrdered(byChild: "author").queryEqual(toValue: username).observe(.childRemoved, with: { (snapshot) -> Void in
            let index = self.indexOfUp(snapshot)
            //print(index)
            self.ups.remove(at: index)
            self.upCollectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
        })
        
        //On Up changed in firebase
        self.ref.child("ups").queryOrdered(byChild: "author").queryEqual(toValue: username).observe(.childChanged, with: { (snapshot) -> Void in
            let index = self.indexOfUp(snapshot)
            self.ups[index] = snapshot
            self.upCollectionView.reloadItems(at: [IndexPath(row: index, section:  0)])
        })
    }
    
    func getFriendFromData(_ friends: FIRDataSnapshot) -> [Friend]{
        var newFriends = [Friend]()
        for child in friends.children{
            let newFriend = Friend(snapshot: child as? FIRDataSnapshot)
            newFriends.append(newFriend)
        }
        
        return newFriends
    }
    
    func makeFriendsString(_ friends: [Friend]) -> String {
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
    
    func handleLongPress(_ gestureReconizer: UILongPressGestureRecognizer) {
        /*
        if gestureReconizer.state != UIGestureRecognizerState.Ended {
            return
        }
 */
        
        let p = gestureReconizer.location(in: self.upCollectionView)
        let indexPath = self.upCollectionView.indexPathForItem(at: p)
        
        if let index = indexPath {
            let cell = self.upCollectionView.cellForItem(at: index) as! UpCollectionViewCell
            // do stuff with your cell, for example print the indexPath
            cell.wobble()
            print(index.row, terminator: "")
        } else {
            print("Could not find index path", terminator: "")
        }
    }
    
    func indexOfUp(_ snapshot: FIRDataSnapshot) -> Int {
        var index = 0
        for  item in self.ups {
            if (snapshot.key == item.key) {
                return index
            }
            index += 1
        }
        return -1
    }
    
    func handleLongGesture(_ gesture: UILongPressGestureRecognizer) {
        
        switch(gesture.state) {
            
        case UIGestureRecognizerState.began:
            guard let selectedIndexPath = self.upCollectionView.indexPathForItem(at: gesture.location(in: self.upCollectionView)) else {
                break
            }
            upCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case UIGestureRecognizerState.changed:
        upCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case UIGestureRecognizerState.ended:
            upCollectionView.endInteractiveMovement()
        default:
            upCollectionView.cancelInteractiveMovement()
        }
        
        
    }
    
    func removeUpRequests(_ key: String){
        
        self.ref.child(Constants.InquiryFields.inquiry).queryOrdered(byChild: Constants.InquiryFields.upID).queryEqual(toValue: key).observeSingleEvent(of: .value, with: { (snapshot) -> Void in
            for item in snapshot.children {
                self.ref.child(Constants.InquiryFields.inquiry).child((item as AnyObject).key).removeValue()
            }
        })
        
        self.ref.child(Constants.ResponseFields.response).queryOrdered(byChild: Constants.ResponseFields.upID).queryEqual(toValue: key).observeSingleEvent(of: .value, with: { (snapshot) -> Void in
            for item in snapshot.children {
                self.ref.child(Constants.ResponseFields.response).child((item as AnyObject).key).removeValue()
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (upToEdit != nil) {
            let destination = segue.destination as! CreateUpViewController
            destination.upToEdit = upToEdit
        }
        upToEdit = nil
    }

}
    

