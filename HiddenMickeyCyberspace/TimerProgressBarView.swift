//
//  TimerProgressBarView.swift
//  HiddenMickeyCyberspace
//
//  Created by Justin Rodriguez on 2/12/22.
//

import UIKit

class TimerProgressBarView: UIView {
    
    var totalTime: Float = 60
    var currentTime: Float = 60
    let shapeLayer = CAShapeLayer()
    var lineWidth = 16

    //initWithFrame to init view from code
    override init(frame: CGRect) {
      super.init(frame: frame)
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    }
    
    //common func to init our view
    func setupView() {
        
        backgroundColor = .clear
        
        var percentComplete =  currentTime / totalTime
        if percentComplete > 1 {
            percentComplete = 1
        }
        
        let angleComplete = percentComplete * 2 * Float(CGFloat.pi)
        let xPos = self.bounds.width / 2
        let yPos = self.bounds.height / 2
        let startAngle = -(0.5 * CGFloat.pi)
        
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: xPos, y: yPos), radius: self.bounds.width / 2, startAngle: startAngle, endAngle: CGFloat(angleComplete) + startAngle, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.backgroundColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = CGFloat(lineWidth)
        shapeLayer.strokeColor = HMCHighlightColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
//        shapeLayer.strokeEnd = 0.83
        
        let trackLayer = CAShapeLayer()
        let trackPath = UIBezierPath(arcCenter: CGPoint(x: xPos, y: yPos), radius: self.bounds.width / 2, startAngle: startAngle, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = trackPath.cgPath
        trackLayer.backgroundColor = UIColor.clear.cgColor
        trackLayer.lineWidth = CGFloat(lineWidth) - 0.5
        trackLayer.strokeColor = UIColor.clear.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        
        self.layer.addSublayer(trackLayer)
        self.layer.addSublayer(shapeLayer)
        shapeLayer.lineCap = .round
//        animateBar()
    }
    
    func updateCurrentTime(secondsLeft: Float) {
        currentTime = secondsLeft
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        setupView()
//        animateBar()
    }
    
    func animateBar() {
//        setupView()
//        shapeLayer.strokeEnd = 0.75
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 1
        animation.toValue = 0
        animation.duration = 62
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: "circleAnimation")
    }
}
