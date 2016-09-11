//
//  DownButton.swift
//  Up
//
//  Created by David Taylor on 9/11/16.
//  Copyright © 2016 Hyper Elephant. All rights reserved.
//

import UIKit

@IBDesignable

class DownButton: UIButton {

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        UpStyleKit.drawDownButton()
    }
 

}
