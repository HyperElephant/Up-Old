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
    private var _refHandle: FIRDatabaseHandle!
    
    func getUpSnapshot(upID: String) -> FIRDataSnapshot? {
        print(upID)
        var data = FIRDataSnapshot()
        ref = FIRDatabase.database().reference().child("ups")
        ref.child(upID).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            data = snapshot
            print("Snapshot: ", snapshot)
            print("Data In: ", data)
        })
        print("Data out: ", data)
        return data
    }
    
}
