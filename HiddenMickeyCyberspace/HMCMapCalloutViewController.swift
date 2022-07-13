//
//  HMCMapCalloutViewController.swift
//  HiddenMickeyCyberspace
//
//  Created by Justin Rodriguez on 5/10/22.
//

import UIKit

protocol HMCMapCalloutViewControllerDelegate {
    func playRide(ride: HMCRide)
}

class HMCMapCalloutViewController: UIViewController {

    @IBOutlet weak var eggImageView: UIImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var rideTitleLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    var delegate: HMCMapCalloutViewControllerDelegate?
    var ride: HMCRide?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eggImageView.isHidden = true
        self.view.backgroundColor = HMCBackgroundColor2.withAlphaComponent(0.5)
        self.cardView.layer.cornerRadius = 25
        let attributedButtonTitle = NSAttributedString(string: "Play",
                                                       attributes: [NSAttributedString.Key.foregroundColor : HMCTextColor2, NSAttributedString.Key.font : UIFont(name: "Avenir Black", size: 24)])
        playButton.setAttributedTitle(attributedButtonTitle, for: .normal)
        playButton.backgroundColor = HMCButtonColor2
        playButton.layer.cornerRadius = 25
        cardView.backgroundColor = HMCBackgroundColor1
        rideTitleLabel.textColor = HMCTextColor1
        highScoreLabel.textColor = HMCTextColor1
        difficultyLabel.textColor = HMCTextColor1
        isModalEnabled(isHidden: true)
    }
    
    func configure(ride: HMCRide) {
        self.ride = ride
        
        guard var image = eggImageView.image else {
            return
        }
        
        image = withHalfOverlayColor(myImage: image, color: ride.colors.headColor, isBottom: true)
        eggImageView.image = withHalfOverlayColor(myImage: image, color: ride.colors.earColor, isBottom: false)
        eggImageView.isHidden = false
        
        rideTitleLabel.text = ride.title
        highScoreLabel.text = "High Score: \(ride.highScore <= 0 ? "-" : String(ride.highScore))"
        difficultyLabel.text = "Difficulty: \(ride.difficulty)"
        if ride.isPremiumRide && !UserDefaults.standard.bool(forKey: hasOptedInToFakePurchaseKey) {
            let attributedButtonTitle = NSAttributedString(string: "Unlock",
                                                           attributes: [NSAttributedString.Key.foregroundColor : HMCTextColor2, NSAttributedString.Key.font : UIFont(name: "Avenir Black", size: 24)])
            playButton.setAttributedTitle(attributedButtonTitle, for: .normal)
        }
        isModalEnabled(isHidden: false)
    }
    
    func isModalEnabled(isHidden: Bool) {
        rideTitleLabel.isHidden = isHidden
        highScoreLabel.isHidden = isHidden
        playButton.isHidden = isHidden
    }
    
    @IBAction func didPressCloseButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func didPressPlayButton(_ sender: Any) {
        self.dismiss(animated: true)
        if let ride = ride {
            delegate?.playRide(ride: ride)
        }
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
