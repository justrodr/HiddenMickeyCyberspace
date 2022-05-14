//
//  HMCProfileViewController.swift
//  HiddenMickeyCyberspace
//
//  Created by Justin Rodriguez on 5/9/22.
//

import UIKit

protocol HMCProfileViewControllerDelegate {
    func didUpdateUsername()
}

class HMCProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var clearLocalDataButton: UIButton!
    @IBOutlet weak var unlockRidesButton: UIButton!
    @IBOutlet weak var usernameTextfield: UITextField!
    
    var delegate: HMCProfileViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let requestHandler = HMCRequestHandler()
        self.view.backgroundColor = HMCBackgroundColor1
        unlockRidesButton.isHidden = true
        requestHandler.readProfileTabConfig {
            if isUnlockButtonEnabled == true {
                self.unlockRidesButton.isHidden = false
            }
        }
        
        configureButton(title: "Clear local data", button: clearLocalDataButton)
        configureButton(title: "Unlock all rides", button: unlockRidesButton)
        usernameTextfield.textColor = HMCTextColor1
        profileImage.layer.cornerRadius = 100
        usernameTextfield.delegate = self
        if let username = UserDefaults.standard.string(forKey: usernameKey) {
            usernameTextfield.text = username
        }
    }
    
    func configureButton(title: String, button: UIButton) {
        let attributedButtonTitle = NSAttributedString(string: title,
                                                       attributes: [NSAttributedString.Key.foregroundColor : HMCTextColor2, NSAttributedString.Key.font : UIFont(name: "Avenir Black", size: 24)])
        button.setAttributedTitle(attributedButtonTitle, for: .normal)
        button.backgroundColor = HMCButtonColor2
        button.layer.cornerRadius = 25
    }
    
    @IBAction func didPressClearLocalData(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure you want to clear local data?", message: "All of your game history will be deleted", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes clear local data", style: .default, handler: { action in
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func didPressUnlockRidesButton(_ sender: Any) {
        let alert = UIAlertController(title: unlockRidesAlertMessage, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: unlockRidesAlertButton, style: .default, handler: { action in
            UserDefaults.standard.set(true, forKey: hasOptedInToFakePurchaseKey)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

extension HMCProfileViewController : UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let enteredText : String = textField.text else {
            return true
        }
        
        if enteredText == natalieCheatCode {
            UserDefaults.standard.set(true, forKey: hasUsedNatlieUFunnyCheatCodeKey)
        } else {
            UserDefaults.standard.set(false, forKey: hasUsedNatlieUFunnyCheatCodeKey)
        }
        UserDefaults.standard.set(enteredText, forKey: usernameKey)
        delegate?.didUpdateUsername()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if let _ = string.rangeOfCharacter(from: .punctuationCharacters) {
            // Do not allow upper case letters
            return false
        }
        
        if let _ = string.rangeOfCharacter(from: .capitalizedLetters) {
            // Do not allow upper case letters
            return false
        }
        
        if let _ = string.rangeOfCharacter(from: .whitespacesAndNewlines) {
            // Do not allow upper case letters
            return false
        }

        return true
    }
    
}
