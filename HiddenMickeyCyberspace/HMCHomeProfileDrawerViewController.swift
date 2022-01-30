//
//  HMCHomeProfileDrawerViewController.swift
//  HiddenMickeyCyberspace
//
//  Created by Justin Rodriguez on 6/26/21.
//

import UIKit

protocol HMCHomeProfileDrawerViewControllerDelegate {
    func showPlayNowARView()
}

class HMCHomeProfileDrawerViewController: UIViewController {

    @IBOutlet weak var testButton: UIButton!
    
    var delegate: HMCHomeProfileDrawerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testButton.backgroundColor = HMCBlue
        testButton.layer.cornerRadius = testButton.frame.height / 3
    }

    @IBAction func didPressTestButton(_ sender: Any) {
        delegate?.showPlayNowARView()
    }
}
