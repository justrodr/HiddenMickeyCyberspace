//
//  HMCFinalScoreViewController.swift
//  HiddenMickeyCyberspace
//
//  Created by Justin Rodriguez on 8/31/21.
//

import UIKit

class HMCFinalScoreViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setScore(score: Int) {
        scoreLabel?.text = String(score)
    }

}
