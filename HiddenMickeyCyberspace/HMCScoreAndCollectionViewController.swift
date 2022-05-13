//
//  HMCScoreAndCollectionViewController.swift
//  HiddenMickeyCyberspace
//
//  Created by Justin Rodriguez on 5/3/22.
//

import UIKit

class HMCScoreAndCollectionViewController: UIViewController {

    @IBOutlet weak var overallHighScoreTitleLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var ridesTitleLabel: UILabel!
    @IBOutlet weak var ridesPlayedTitleLabel: UILabel!
    @IBOutlet weak var ridesPlayedLabel: UILabel!
    @IBOutlet weak var scoresTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = HMCBackgroundColor1
        overallHighScoreTitleLabel.textColor = HMCTextColor1
        highScoreLabel.textColor = HMCHighlightColor
        ridesTitleLabel.textColor = HMCTextColor1
        ridesPlayedTitleLabel.textColor = HMCTextColor1
        ridesPlayedLabel.textColor = HMCHighlightColor
        scoresTitleLabel.textColor = HMCTextColor1
        highScoreLabel.text = String(UserDefaults.standard.integer(forKey: totalHighScoreKey))
        setRidesPlayed()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        registerNib()

        // Do any additional setup after loading the view.
    }
    
    func setRidesPlayed() {
        let ridesPlayed = titleRideMap.filter { $0.value.hasPlayedRide == true }
        ridesPlayedLabel?.text = "\(ridesPlayed.count)/\(titleRideMap.count)"
    }

}

extension HMCScoreAndCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ridesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HMCCollectionViewCellIdentifier", for: indexPath) as? HMCCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(ride: ridesArray[indexPath.item])
        return cell
    }
    
    func registerNib() {
        let nib = UINib(nibName: HMCCollectionViewCell.nibName, bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: "HMCCollectionViewCellIdentifier")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top:0, left: 32, bottom: 0, right: 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let referenceHeight = (collectionView.safeAreaLayoutGuide.layoutFrame.width / 2) - 8 - 32
        let referenceWidth = (collectionView.safeAreaLayoutGuide.layoutFrame.width / 2) - 8 - 32
        return CGSize(width: referenceWidth, height: referenceHeight)
    }
}
