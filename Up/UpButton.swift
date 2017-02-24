//
//  UpButton.swift
//  Up
//
//  Created by David Taylor on 9/11/16.
//  Copyright © 2016 Hyper Elephant. All rights reserved.
//

import UIKit

@IBDesignable

class UpButton: UIButton {

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        UpStyleKit.drawUpButton()
    }
    

}
