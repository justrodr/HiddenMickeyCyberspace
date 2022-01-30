//
//  HMCLocation.swift
//  HiddenMickeyCyberspace
//
//  Created by Justin Rodriguez on 6/10/21.
//

import Foundation
import CoreLocation

class HMCParkLocation {
    var centerPoint: CLLocationCoordinate2D
    var radius: Int
    var parkName: String
    var parkID: String
    var attractions: [HMCAttractionLocation] = []
    
    init(parkName: String, parkID: String, centerPoint: CLLocationCoordinate2D, radius: Int) {
        self.parkName = parkName
        self.parkID = parkID
        self.centerPoint = centerPoint
        self.radius = radius
    }
}

class HMCAttractionLocation {
    var centerPoint: CLLocationCoordinate2D
    var radius: Int
    var attractionName: String
    var attractionID: String
    
    init(attractionName: String, attractionID: String, centerPoint: CLLocationCoordinate2D, radius: Int) {
        self.attractionName = attractionName
        self.attractionID = attractionID
        self.centerPoint = centerPoint
        self.radius = radius
    }
}
