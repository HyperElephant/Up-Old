//
//  ResponsesViewController.swift
//  Up
//
//  Created by David Taylor on 8/31/16.
//  Copyright © 2016 Hyper Elephant. All rights reserved.
//

import UIKit
import Firebase

class ResponsesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    let reuseIdentifier = "upCell"
    var responses: [FIRDataSnapshot]! = []
    var ups: [FIRDataSnapshot]! = []
    
    var side = CGFloat(0)
    var ref: FIRDatabaseReference!
    private var _refHandle: FIRDatabaseHandle!
    
    @IBOutlet weak var responsesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        side = (self.view.frame.width / 2) - CGFloat(30)
        
        responsesCollectionView.delegate = self
        responsesCollectionView.dataSource = self
        
        configureIncomingDatabase()
        // Do any additional setup after loading the view.
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ResponseCollectionViewCell
        
        
        if let up = Up(snapshot: ups[indexPath.row]), response = Response(snapshot: responses[indexPath.row]) {
            cell.key = response.id
            cell.upID = up.id
            var isUpString = "not up"
            if response.isUp == true {
                isUpString = "up"
            }
            cell.responseTitleLabel!.text = "\(response.responderName) is \(isUpString) to \(up.title)"
            
        } else {
            cell.responseTitleLabel!.text = "Error"
        }
        
        cell.layer.backgroundColor = UIColor.whiteColor().CGColor
        cell.layer.borderColor = UIColor.grayColor().CGColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = side/2
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSizeMake(side, side);
    }
    
    
    //Helper functions
    func configureIncomingDatabase() {
        ref = FIRDatabase.database().reference()
        let username = FIRAuth.auth()?.currentUser?.displayName
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child(Constants.ResponseFields.response).queryOrderedByChild(Constants.ResponseFields.authorName).queryEqualToValue(username).observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            self.responses.append(snapshot)
            self.configureUpsDatabase(snapshot.value![Constants.ResponseFields.upID] as! String!)
        })
        
        self.ref.child(Constants.ResponseFields.response).queryOrderedByChild(Constants.ResponseFields.authorName).queryEqualToValue(username).observeEventType(.ChildRemoved, withBlock: { (snapshot) -> Void in
            let index = self.indexOfResponse(snapshot)
            self.ups.removeAtIndex(index)
            self.responses.removeAtIndex(index)
            self.responsesCollectionView.deleteItemsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)])
        })
    }
    
    func configureUpsDatabase(upID: String) {
        ref = FIRDatabase.database().reference().child(Constants.UpFields.ups)
        ref.child(upID).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            self.ups.append(snapshot)
            self.responsesCollectionView.insertItemsAtIndexPaths([NSIndexPath(forRow: self.ups.count-1, inSection: 0)])
        })
    }
    
    func indexOfResponse(snapshot: FIRDataSnapshot) -> Int {
        var index = 0
        for  item in self.responses {
            if (snapshot.key == item.key) {
                return index
            }
            index += 1
        }
        return -1
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
