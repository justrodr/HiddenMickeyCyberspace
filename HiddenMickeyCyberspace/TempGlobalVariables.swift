//
//  TempGlobalVariables.swift
//  HiddenMickeyCyberspace
//
//  Created by Justin Rodriguez on 1/29/22.
//

import Foundation
import MapKit

struct HMCMickeyColors {
    var headColor: UIColor
    var earColor: UIColor
}

let buzzLightyearRide = Place(title: "Buzz Lightyear's Spaceranger Spin", coordinate: CLLocationCoordinate2D(latitude: 28.41823945047847, longitude: -81.579562159756))

let colorMapping: [String : HMCMickeyColors] = [
    "Buzz Lightyear's Spaceranger Spin" : HMCMickeyColors(headColor: UIColor(displayP3Red: 98/255, green: 135/255, blue: 39/255, alpha: 1), earColor: UIColor(displayP3Red: 141/255, green: 63/255, blue: 128/255, alpha: 1))
]


