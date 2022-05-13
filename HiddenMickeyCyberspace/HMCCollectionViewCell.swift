//
//  HMCCollectionViewCell.swift
//  HiddenMickeyCyberspace
//
//  Created by Justin Rodriguez on 4/19/22.
//

import UIKit

class HMCCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var leftEarView: UIView!
    @IBOutlet weak var rightEarView: UIView!
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var rideTitleLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    
    private var shadeView : UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = HMCCardBackgroundColor1
        self.layer.cornerRadius = 32
        self.rightEarView.layer.cornerRadius = 35/2
        self.leftEarView.layer.cornerRadius = 35/2
        self.headView.layer.cornerRadius = 25
        rightEarView.backgroundColor = .clear
        leftEarView.backgroundColor = .clear
        headView.backgroundColor = .clear
        rideTitleLabel.textColor = HMCTextColor2
        highScoreLabel.textColor = HMCTextColor2
    }
    
    override var reuseIdentifier: String {
        return "HMCCollectionViewCellIdentifier"
    }
    
    class var nibName: String {
        return "HMCCollectionViewCell"
    }
    
    func configure(ride: HMCRide) {
        rightEarView.backgroundColor = ride.colors.earColor
        leftEarView.backgroundColor = ride.colors.earColor
        headView.backgroundColor = ride.colors.headColor
        if let earBorderColor = ride.colors.earBorderColor {
            leftEarView.layer.borderWidth = 3
            leftEarView.layer.borderColor = earBorderColor.cgColor
            rightEarView.layer.borderWidth = 3
            rightEarView.layer.borderColor = earBorderColor.cgColor
        }
        if let headBorderColor = ride.colors.headBorderColor {
            headView.layer.borderWidth = 3
            headView.layer.borderColor = headBorderColor.cgColor
        }
        rideTitleLabel.text = "\(ride.title) \(ride.park)"
        if ride.highScore > 0 {
            highScoreLabel.text = "High Score: \(ride.highScore)"
        } else {
            highScoreLabel.text = "High Score: -"
        }
        
        if !ride.hasPlayedRide {
            self.shadeView?.removeFromSuperview()
            let shadeView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
            shadeView.clipsToBounds = true
            shadeView.backgroundColor = HMCCardBackgroundColor1.withAlphaComponent(0.5)
            self.addSubview(shadeView)
            self.shadeView = shadeView
        }
    }

}
