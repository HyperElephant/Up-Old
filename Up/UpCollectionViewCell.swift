//
//  UpCollectionViewCell.swift
//  Up
//
//  Created by David Taylor on 6/25/16.
//  Copyright © 2016 Hyper Elephant. All rights reserved.
//

import UIKit

class UpCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var label: UILabel!
    var limbo = false
    
    func showProgress() -> Bool{
        
        // set up some values to use in the curve
        let ovalStartAngle = CGFloat(90.01 * M_PI/180)
        let ovalEndAngle = CGFloat(90 * M_PI/180)
        let ovalRect = self.frame;
        
        // create the bezier path
        let ovalPath = UIBezierPath()
        
        ovalPath.addArcWithCenter(CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)),
            radius: CGRectGetWidth(ovalRect) / 2,
            startAngle: ovalStartAngle,
            endAngle: ovalEndAngle, clockwise: true)
        
        // create an object that represents how the curve
        // should be presented on the screen
        let progressLine = CAShapeLayer()
        progressLine.path = ovalPath.CGPath
        progressLine.strokeColor = UIColor(red: 178/255, green: 47/255, blue: 152/255, alpha: 0.5).CGColor
        progressLine.fillColor = UIColor.clearColor().CGColor
        progressLine.lineWidth = 30.0
        progressLine.lineCap = kCALineCapRound
        
        // add the curve to the screen
        self.layer.addSublayer(progressLine)
        
        // create a basic animation that animates the value 'strokeEnd'
        // from 0.0 to 1.0 over 3.0 seconds
        let animateStrokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        animateStrokeEnd.duration = 1.0
        animateStrokeEnd.fromValue = 0.0
        animateStrokeEnd.toValue = 1.0
        
        // add the animation
        progressLine.addAnimation(animateStrokeEnd, forKey: "Send Buffer")
        
        return true;
        
    }
        
}
