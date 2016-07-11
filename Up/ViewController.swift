//
//  ViewController.swift
//  Up
//
//  Created by David Taylor on 6/25/16.
//  Copyright © 2016 Hyper Elephant. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let reuseIdentifier = "cell";
    var items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48"]
    
    var side = CGFloat(0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        side = (self.view.frame.width / 2) - CGFloat(30)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UpCollectionViewCell
        
        cell.label.text = self.items[indexPath.item]
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
        
        /*
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! UpCollectionViewCell
        
        if(cell.limbo == false){
            cell.limbo = true
            cell.showProgress()
        } else {
            cell.limbo = false
            cell.layer.sublayers?.removeLast()

        }
*/
        
        
        /*
        UIView.animateWithDuration(4, delay: 0, options: UIViewAnimationOptions.Autoreverse, animations: { () -> Void in
            
            cell.backgroundColor = UIColor(red: 178/255, green: 47/255, blue: 152/255, alpha: 1)
            
            }, completion: {finished in
                print("sent");
                
        })
*/
        
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {        
        return CGSizeMake(side, side);
    }
    
    
    
    
}

