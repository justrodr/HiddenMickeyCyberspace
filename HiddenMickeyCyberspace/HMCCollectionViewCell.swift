//
//  HMCCollectionViewCell.swift
//  HiddenMickeyCyberspace
//
//  Created by Justin Rodriguez on 4/19/22.
//

import UIKit

class HMCCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var eggImageView: UIImageView!
    @IBOutlet weak var rideTitleLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    
    private var shadeView : UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = HMCCardBackgroundColor1
        self.layer.cornerRadius = 32
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
        
        guard var image = eggImageView.image else {
            return
        }
        
        image = withHalfOverlayColor(myImage: image, color: ride.colors.headColor, isBottom: true)
        eggImageView.image = withHalfOverlayColor(myImage: image, color: ride.colors.earColor, isBottom: false)
        
        rideTitleLabel.text = "\(ride.title) \(ride.park)"
        if ride.highScore > 0 {
            highScoreLabel.text = "High Score: \(ride.highScore) \n Difficulty: \(ride.difficulty)"
        } else {
            highScoreLabel.text = "High Score: - \n Difficulty: \(ride.difficulty)"
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
    
    func withHalfOverlayColor(myImage: UIImage, color: UIColor, isBottom: Bool) -> UIImage
      {
        let rect = CGRect(x: 0, y: 0, width: myImage.size.width, height: myImage.size.height)


        UIGraphicsBeginImageContextWithOptions(myImage.size, false, myImage.scale)
        myImage.draw(in: rect)

        let context = UIGraphicsGetCurrentContext()!
        context.setBlendMode(CGBlendMode.sourceIn)

        context.setFillColor(color.cgColor)
          
        let rectToFill = CGRect(x: 0,
                                y: isBottom ? myImage.size.height*0.6 : 0,
                                width: myImage.size.width,
                                height: isBottom ? myImage.size.height*0.4 : myImage.size.height*0.6)
        context.fill(rectToFill)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
      }

}
    
