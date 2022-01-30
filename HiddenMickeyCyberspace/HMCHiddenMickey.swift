//
//  HMCHiddenMickey.swift
//  HiddenMickeyCyberspace
//
//  Created by Justin Rodriguez on 6/10/21.
//

import Foundation
import CoreLocation

class HMCHiddenMickey {
    var coordinates: CLLocationCoordinate2D
    var ride: String //*** Should these be objects??
    var park: String
    var ID: String
    var size: Int
    var patternAsset: String?
    
    init(coordinates: CLLocationCoordinate2D, ride: String, park: String, ID: String, size: Int, patternAsset: String?) {
        self.coordinates = coordinates
        self.ride = ride
        self.park = park
        self.ID = ID
        self.size = size
        self.patternAsset = patternAsset
    }
}
