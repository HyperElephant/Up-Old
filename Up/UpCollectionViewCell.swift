//
//  UpCollectionViewCell.swift
//  Up
//
//  Created by David Taylor on 6/25/16.
//  Copyright © 2016 Hyper Elephant. All rights reserved.
//

import UIKit

@IBDesignable

class UpCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var friendsLabel: UILabel!
    
    let animationRotateDegres: CGFloat = 0.5
    let animationTranslateX: CGFloat = 1.0
    let animationTranslateY: CGFloat = 1.0
    let count: Int = 1
    
    var limbo = false
    
    func showProgress() -> Bool{
        
        // set up some values to use in the curve
        let ovalStartAngle = CGFloat(90.01 * M_PI/180)
        let ovalEndAngle = CGFloat(90 * M_PI/180)
        let ovalRect = self.frame;
        
        // create the bezier path
        let ovalPath = UIBezierPath()
        
        ovalPath.addArc(withCenter: CGPoint(x: self.frame.midX, y: self.frame.midY),
            radius: ovalRect.width / 2,
            startAngle: ovalStartAngle,
            endAngle: ovalEndAngle, clockwise: true)
        
        // create an object that represents how the curve
        // should be presented on the screen
        let progressLine = CAShapeLayer()
        progressLine.path = ovalPath.cgPath
        progressLine.strokeColor = UIColor(red: 178/255, green: 47/255, blue: 152/255, alpha: 0.5).cgColor
        progressLine.fillColor = UIColor.clear.cgColor
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
        progressLine.add(animateStrokeEnd, forKey: "Send Buffer")
        
        return true;
        
    }
    
    override func draw(_ rect: CGRect) {

        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 1, y: 1, width: rect.width - 2, height: rect.height - 2))
        UIColor.white.setFill()
        ovalPath.fill()
        UpStyleKit.outlineColor.setStroke()
        ovalPath.lineWidth = 1
        ovalPath.stroke()
    }

    func wobble() {
                
        let leftOrRight: CGFloat = (count % 2 == 0 ? 1 : -1)
        let rightOrLeft: CGFloat = (count % 2 == 0 ? -1 : 1)
        let leftWobble: CGAffineTransform = CGAffineTransform(rotationAngle: degreesToRadians(animationRotateDegres * leftOrRight))
        let rightWobble: CGAffineTransform = CGAffineTransform(rotationAngle: degreesToRadians(animationRotateDegres * rightOrLeft))
        let moveTransform: CGAffineTransform = leftWobble.translatedBy(x: -animationTranslateX, y: -animationTranslateY)
        let conCatTransform: CGAffineTransform = leftWobble.concatenating(moveTransform)
        
        transform = rightWobble // starting point
        
        UIView.animate(withDuration: 0.1, delay: 0.08, options: [.allowUserInteraction, .repeat, .autoreverse], animations: { () -> Void in
            self.transform = conCatTransform
            }, completion: nil)
    }
    
    func stopWobble() {
        self.layer.removeAllAnimations();
    }
    
    func degreesToRadians(_ x: CGFloat) -> CGFloat {
        return CGFloat(M_PI) * x / 180.0
    }
    
        
}
