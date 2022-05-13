//
//  HMCFinalScoreViewController.swift
//  HiddenMickeyCyberspace
//
//  Created by Justin Rodriguez on 8/31/21.
//

import UIKit

protocol HMCFinalScoreViewControllerDelegate: AnyObject {
    func didPressPlayAgain(ride: HMCRide?)
}


class HMCFinalScoreViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel?
    @IBOutlet weak var highScoreLabel: UILabel?
    @IBOutlet weak var ridesPlayedLabel: UILabel?
    @IBOutlet weak var highScoreTitleLabel: UILabel?
    @IBOutlet weak var finalScoreTitleLabel: UILabel?
    @IBOutlet weak var ridesPlayedTitleLabel: UILabel?
    @IBOutlet weak var dividerLineView: UIView?
    @IBOutlet weak var scoresTitleLabel: UILabel?
    @IBOutlet weak var playAgainButton: UIButton?
    
    var score: Int = 0
    weak var delegate: HMCFinalScoreViewControllerDelegate?
    var ride: HMCRide?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = HMCBackgroundColor1
        scoreLabel?.textColor = HMCTextColor1
        scoreLabel?.isHidden = true
        highScoreLabel?.textColor = HMCTextColor1
        highScoreLabel?.isHidden = true
        ridesPlayedLabel?.textColor = HMCTextColor1
        highScoreLabel?.textColor = HMCTextColor1
        finalScoreTitleLabel?.textColor = HMCTextColor1
        ridesPlayedTitleLabel?.textColor = HMCTextColor1
        dividerLineView?.layer.cornerRadius = 2.5
        dividerLineView?.backgroundColor = HMCHighlightColor
        scoresTitleLabel?.textColor = HMCTextColor1
        highScoreTitleLabel?.textColor = HMCTextColor1
        playAgainButton?.layer.cornerRadius = 8
        let attributedButtonTitle = NSAttributedString(string: "Play Again",
                                                       attributes: [NSAttributedString.Key.foregroundColor : HMCTextColor2, NSAttributedString.Key.font : UIFont(name: "Avenir Black", size: 24)])
        playAgainButton?.setAttributedTitle(attributedButtonTitle, for: .normal)
        playAgainButton?.backgroundColor = HMCButtonColor2
        
        setScore()
        setRidesPlayed()
    }
    
    func setScore() {
        scoreLabel?.text = String(score)
        let totalHighScore = UserDefaults.standard.integer(forKey: totalHighScoreKey)
        if score > totalHighScore {
            UserDefaults.standard.set(score, forKey: totalHighScoreKey)
        }
        if ride?.highScore ?? 0 < score {
            highScoreLabel?.text = String(score)
            highScoreTitleLabel?.text = "New High Score!"
            ride?.setNewHighScore(score: score)
        } else {
            highScoreTitleLabel?.text = "High Score"
            if let highScore = ride?.highScore {
                highScoreLabel?.text = String(highScore)
            } else {
                highScoreLabel?.text = "-"
            }
        }
        scoreLabel?.isHidden = false
        highScoreLabel?.isHidden = false
    }
    
    func setRidesPlayed() {
        ride?.setHasPlayedRide(didPlayRide: true)
        let ridesPlayed = titleRideMap.filter { $0.value.hasPlayedRide == true }
        ridesPlayedLabel?.text = "\(ridesPlayed.count)/\(titleRideMap.count)"
    }

    @IBAction func didPressPlayAgainButton(_ sender: Any) {
        delegate?.didPressPlayAgain(ride: ride)
    }
}
