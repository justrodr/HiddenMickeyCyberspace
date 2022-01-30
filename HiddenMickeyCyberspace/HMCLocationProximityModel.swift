//
//  HMCLocationProximityModel.swift
//  HiddenMickeyCyberspace
//
//  Created by Justin Rodriguez on 6/10/21.
//

import Foundation

class HMCLocationProximityModel : HMCModel {
    // On initialize, pull location data from BE
    // On location change, calculate proximity, if in range, return state
    
    override init() {
        super.init()
        requestHandler.getParkAndRideLocationInformation()
    }
}
