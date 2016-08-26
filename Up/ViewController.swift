//
//  ViewController.swift
//  Up
//
//  Created by David Taylor on 6/25/16.
//  Copyright © 2016 Hyper Elephant. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let reuseIdentifier = "upCell"
    var ups: [FIRDataSnapshot]! = []
    

    var side = CGFloat(0)
    var ref: FIRDatabaseReference!
    private var _refHandle: FIRDatabaseHandle!

    @IBOutlet weak var upCollectionView: UICollectionView!
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue){

        upCollectionView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.upCollectionView?.delegate = self
        self.upCollectionView?.dataSource = self
        
        side = (self.view.frame.width / 2) - CGFloat(30)
        
        configureDatabase()
        
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

        //cell.label!.text = "here"
        cell.label!.text = up.title

        /*
        let upsSnapshot: FIRDataSnapshot! = self.ups[indexPath.item]
        let up = upsSnapshot.value as! Dictionary<String, String>
        let name = up["name"] as String!
        
        cell.label.text = name
         */
        cell.layer.backgroundColor = UIColor.whiteColor().CGColor
        cell.layer.borderColor = UIColor.grayColor().CGColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = side/2
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {        
        return CGSizeMake(side, side);
    }
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("ups").observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            self.ups.append(snapshot)
            self.upCollectionView.insertItemsAtIndexPaths([NSIndexPath(forRow: self.ups.count-1, inSection: 0)])
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

}
    

