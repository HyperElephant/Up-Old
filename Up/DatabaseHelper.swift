//
//  DatabaseHelper.swift
//  Up
//
//  Created by David Taylor on 8/28/16.
//  Copyright © 2016 Hyper Elephant. All rights reserved.
//

import UIKit
import Firebase

class DatabaseHelper: NSObject {
    
    var ref: FIRDatabaseReference!
    fileprivate var _refHandle: FIRDatabaseHandle!
    
    
    //DOES NOT WORK
    func getUpSnapshot(_ upID: String) -> FIRDataSnapshot? {
        print(upID)
        var data = FIRDataSnapshot()
        ref = FIRDatabase.database().reference().child("ups")
        ref.child(upID).observeSingleEvent(of: .value, with: { (snapshot) in
            data = snapshot
            print("Snapshot: ", snapshot)
            print("Data In: ", data)
        })
        print("Data out: ", data)
        return data
    }
    
    
    //Does work
    func indexOfSnapshot(_ snapshot: FIRDataSnapshot, list: [FIRDataSnapshot]) -> Int {
        var index = 0
        for  item in list {
            if (snapshot.key == item.key) {
                return index
            }
            index += 1
        }
        return -1
    }
    
}
