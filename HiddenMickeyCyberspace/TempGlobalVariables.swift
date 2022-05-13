//
//  TempGlobalVariables.swift
//  HiddenMickeyCyberspace
//
//  Created by Justin Rodriguez on 1/29/22.
//

import Foundation
import MapKit
import Firebase

let totalHighScoreKey = "TotalHighScore"
let usernameKey = "usernameKey"
let hasOptedInToFakePurchaseKey = "hasOptedInToFakePurchasekey"
let hasUsedNatlieUFunnyCheatCodeKey = "hasUsedNatlieUFunnyCheatCodeKey"
let natalieCheatCode = "natalieufunny"

struct HMCMickeyColors {
    var headColor: UIColor
    var earColor: UIColor
    var earBorderColor: UIColor?
    var headBorderColor: UIColor?
}

class HMCRide {
    var title: String
    var rideAnnotation: HMCPlace
    var colors: HMCMickeyColors
    var highScore: Int
    var hasPlayedRide: Bool {
        return UserDefaults.standard.bool(forKey: "\(title)\(park)hasPlayed")
    }
    var isPremiumRide: Bool
    var park: String
    var rideID : String {
        return "\(title) \(park)"
    }
    
    init(title: String, coordinate: CLLocationCoordinate2D, isPremiumRide: Bool, park: String, headColor: UIColor, earColor: UIColor, headBorderColor: UIColor? = nil, earBorderColor: UIColor? = nil) {
        self.title = title
        self.rideAnnotation = HMCPlace(title: title, coordinate: coordinate)
        self.colors = HMCMickeyColors(headColor: headColor, earColor: earColor, earBorderColor: earBorderColor, headBorderColor: headBorderColor)
        highScore = UserDefaults.standard.integer(forKey: "\(title)\(park)HighScore")
        self.isPremiumRide = isPremiumRide
        self.park = park
    }
    
    func setNewHighScore(score: Int) {
        UserDefaults.standard.set(score, forKey: "\(title)\(park)HighScore")
        highScore = score
    }
    
    func setHasPlayedRide(didPlayRide: Bool) {
        let hasPlayedRideKey = "\(title)\(park)hasPlayed"
        let hasPlayedRide = UserDefaults.standard.bool(forKey: hasPlayedRideKey)
        if hasPlayedRide != didPlayRide {
            UserDefaults.standard.set(didPlayRide, forKey: hasPlayedRideKey)
        }
    }
}

class HMCPlace: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
    
}

let buzzLightyearRide =  HMCRide(title: "Buzz Lightyear's Spaceranger Spin",
                                 coordinate: CLLocationCoordinate2D(latitude: 28.41823945047847, longitude: -81.579562159756),
                                 isPremiumRide: false,
                                 park: "MK",
                                 headColor: UIColor(displayP3Red: 98/255, green: 135/255, blue: 39/255, alpha: 1),
                                 earColor: UIColor(displayP3Red: 141/255, green: 63/255, blue: 128/255, alpha: 1))

let splashMountainRide = HMCRide(title: "Splash Mountain",
                                 coordinate: CLLocationCoordinate2D(latitude: 28.41939713102671, longitude: -81.584624247281),
                                 isPremiumRide: false,
                                 park: "MK",
                                 headColor: UIColor(displayP3Red: 254/255, green: 125/255, blue: 64/255, alpha: 1),
                                 earColor: UIColor(displayP3Red: 95/255, green: 135/255, blue: 86/255, alpha: 1))

let spaceMountainRide = HMCRide(title: "Space Mountain",
                                coordinate: CLLocationCoordinate2D(latitude: 28.41901488294059, longitude: -81.57817869008407),
                                isPremiumRide: false,
                                park: "MK",
                                headColor: UIColor(displayP3Red: 93/255, green: 180/255, blue: 203/255, alpha: 1),
                                earColor: UIColor(displayP3Red: 250/255, green: 255/255, blue: 251/255, alpha: 1),
                                earBorderColor: UIColor(displayP3Red: 228/255, green: 222/255, blue: 227/255, alpha: 1))

let sevenDwarfsMineTrainRide = HMCRide(title: "Seven Dwarfs Mine Train",
                                coordinate: CLLocationCoordinate2D(latitude: 28.420812554629695, longitude: -81.57931455118064),
                                isPremiumRide: false,
                                park: "MK",
                                headColor: UIColor(displayP3Red: 254/255, green: 234/255, blue: 132/255, alpha: 1),
                                earColor: UIColor(displayP3Red: 36/255, green: 91/255, blue: 177/255, alpha: 1),
                                headBorderColor: UIColor(displayP3Red: 36/255, green: 91/255, blue: 177/255, alpha: 1),
                                earBorderColor:UIColor(displayP3Red: 197/255, green: 61/255, blue: 75/255, alpha: 1))

let underTheSeaRide = HMCRide(title: "Under the Sea - Journey of The Little Mermaid",
                                coordinate: CLLocationCoordinate2D(latitude: 28.421105062503784, longitude: -81.57918580515557),
                                isPremiumRide: false,
                                park: "MK",
                                headColor: UIColor(displayP3Red: 0/255, green: 186/255, blue: 182/255, alpha: 1),
                                earColor: UIColor(displayP3Red: 137/255, green: 109/255, blue: 209/255, alpha: 1),
                                earBorderColor: UIColor(displayP3Red: 239/255, green: 0/255, blue: 58/255, alpha: 1))

let winnieThePoohRide = HMCRide(title: "The Many Adventures of Winnie the Pooh",
                                coordinate: CLLocationCoordinate2D(latitude: 28.42013318720865, longitude: -81.57997770382441),
                                isPremiumRide: false,
                                park: "MK",
                                headColor: UIColor(displayP3Red: 241/255, green: 68/255, blue: 66/255, alpha: 1),
                                earColor: UIColor(displayP3Red: 255/255, green: 206/255, blue: 48/255, alpha: 1))

let mickeysPhilharMagicRide = HMCRide(title: "Mickey's PhilharMagic",
                                coordinate: CLLocationCoordinate2D(latitude: 28.42013898926731, longitude: -81.5813036668187),
                                isPremiumRide: false,
                                park: "MK",
                                headColor: UIColor(displayP3Red: 39/255, green: 79/255, blue: 162/255, alpha: 1),
                                earColor: UIColor(displayP3Red: 244/255, green: 188/255, blue: 37/255, alpha: 1))

let peterPanRide = HMCRide(title: "Peter Pan's Flight",
                                coordinate: CLLocationCoordinate2D(latitude: 28.42034495087855, longitude: -81.58185985963739),
                                isPremiumRide: false,
                                park: "MK",
                                headColor: UIColor(displayP3Red: 123/255, green: 126/255, blue: 52/255, alpha: 1),
                                earColor: UIColor(displayP3Red: 177/255, green: 192/255, blue: 187/255, alpha: 1),
                                headBorderColor: UIColor(displayP3Red: 69/255, green: 68/255, blue: 20/255, alpha: 1))

let hauntedMansionRide = HMCRide(title: "Haunted Mansion",
                                coordinate: CLLocationCoordinate2D(latitude: 28.420176163609334, longitude: -81.58283613331898),
                                isPremiumRide: false,
                                park: "MK",
                                headColor: UIColor(displayP3Red: 100/255, green: 213/255, blue: 231/255, alpha: 1),
                                earColor: UIColor(displayP3Red: 100/255, green: 213/255, blue: 231/255, alpha: 1),
                                headBorderColor: UIColor(displayP3Red: 45/255, green: 113/255, blue: 138/255, alpha: 1),
                                earBorderColor: UIColor(displayP3Red: 45/255, green: 113/255, blue: 138/255, alpha: 1))

let jungleCruiseRide = HMCRide(title: "Jungle Cruise",
                                coordinate: CLLocationCoordinate2D(latitude: 28.41811385912513, longitude: -81.58341675353998),
                                isPremiumRide: false,
                                park: "MK",
                                headColor: UIColor(displayP3Red: 216/255, green: 142/255, blue: 97/255, alpha: 1),
                                earColor: UIColor(displayP3Red: 39/255, green: 65/255, blue: 44/255, alpha: 1))

let piratesOfTheCaribbeanRide = HMCRide(title: "Pirates of the Caribbean",
                                coordinate: CLLocationCoordinate2D(latitude: 28.418175630391126, longitude: -81.5838481935099),
                                isPremiumRide: false,
                                park: "MK",
                                headColor: UIColor(displayP3Red: 186/255, green: 77/255, blue: 77/255, alpha: 1),
                                earColor: UIColor(displayP3Red: 72/255, green: 116/255, blue: 240/255, alpha: 1))

let bigThunderRide = HMCRide(title: "Big Thunder Mountain Railroad",
                                coordinate: CLLocationCoordinate2D(latitude: 28.420351188801774, longitude: -81.58439316754362),
                                isPremiumRide: false,
                                park: "MK",
                                headColor: UIColor(displayP3Red: 230/255, green: 110/255, blue: 86/255, alpha: 1),
                                earColor: UIColor(displayP3Red: 11/255, green: 80/255, blue: 65/255, alpha: 1))

let ridesArray = [
    buzzLightyearRide,
    splashMountainRide,
    spaceMountainRide,
    sevenDwarfsMineTrainRide,
    underTheSeaRide,
    winnieThePoohRide,
    mickeysPhilharMagicRide,
    peterPanRide,
    hauntedMansionRide,
    jungleCruiseRide,
    piratesOfTheCaribbeanRide,
    bigThunderRide
]

let titleRideMap: [String: HMCRide] = [
    "Buzz Lightyear's Spaceranger Spin": buzzLightyearRide,
    "Splash Mountain" : splashMountainRide,
    "Space Mountain" : spaceMountainRide,
    "Seven Dwarfs Mine Train" : sevenDwarfsMineTrainRide,
    "Under the Sea - Journey of The Little Mermaid" : underTheSeaRide,
    "The Many Adventures of Winnie the Pooh" : winnieThePoohRide,
    "Mickey's PhilharMagic" : mickeysPhilharMagicRide,
    "Peter Pan's Flight" : peterPanRide,
    "Haunted Mansion" : hauntedMansionRide,
    "Jungle Cruise" : jungleCruiseRide,
    "Pirates of the Caribbean" : piratesOfTheCaribbeanRide,
    "Big Thunder Mountain Railroad" : bigThunderRide
]


