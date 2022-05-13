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

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var leftEarView: UIView!
    @IBOutlet weak var rightEarView: UIView!
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var rideTitleLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    var delegate: HMCMapCalloutViewControllerDelegate?
    var ride: HMCRide?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = HMCBackgroundColor2.withAlphaComponent(0.5)
        self.cardView.layer.cornerRadius = 25
        self.leftEarView.layer.cornerRadius = leftEarView.frame.height / 2
        self.rightEarView.layer.cornerRadius = rightEarView.frame.height / 2
        self.headView.layer.cornerRadius = headView.frame.height / 2
        let attributedButtonTitle = NSAttributedString(string: "Play",
                                                       attributes: [NSAttributedString.Key.foregroundColor : HMCTextColor2, NSAttributedString.Key.font : UIFont(name: "Avenir Black", size: 24)])
        playButton.setAttributedTitle(attributedButtonTitle, for: .normal)
        playButton.backgroundColor = HMCButtonColor2
        playButton.layer.cornerRadius = 25
        cardView.backgroundColor = HMCBackgroundColor1
        rideTitleLabel.textColor = HMCTextColor1
        highScoreLabel.textColor = HMCTextColor1
        isModalEnabled(isHidden: true)
    }
    
    func configure(ride: HMCRide) {
        self.ride = ride
        leftEarView.backgroundColor = ride.colors.earColor
        rightEarView.backgroundColor = ride.colors.earColor
        if let earBorderColor = ride.colors.earBorderColor {
            leftEarView.layer.borderWidth = 3
            leftEarView.layer.borderColor = earBorderColor.cgColor
            rightEarView.layer.borderWidth = 3
            rightEarView.layer.borderColor = earBorderColor.cgColor
        }
        headView.backgroundColor = ride.colors.headColor
        if let headBorderColor = ride.colors.headBorderColor {
            headView.layer.borderWidth = 3
            headView.layer.borderColor = headBorderColor.cgColor
        }
        
        rideTitleLabel.text = ride.title
        highScoreLabel.text = "High Score: \(ride.highScore <= 0 ? "-" : String(ride.highScore))"
        if ride.isPremiumRide && !UserDefaults.standard.bool(forKey: hasOptedInToFakePurchaseKey) {
            let attributedButtonTitle = NSAttributedString(string: "Unlock",
                                                           attributes: [NSAttributedString.Key.foregroundColor : HMCTextColor2, NSAttributedString.Key.font : UIFont(name: "Avenir Black", size: 24)])
            playButton.setAttributedTitle(attributedButtonTitle, for: .normal)
        }
        isModalEnabled(isHidden: false)
        headView.superview?.bringSubviewToFront(headView)
    }
    
    func isModalEnabled(isHidden: Bool) {
        leftEarView.isHidden = isHidden
        rightEarView.isHidden = isHidden
        headView.isHidden = isHidden
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
