//
//  HMCModelFactory.swift
//  HiddenMickeyCyberspace
//
//  Created by Justin Rodriguez on 6/10/21.
//

import Foundation
import Firebase
import CoreLocation

class HMCRequestHandler {
    
    private static let ref = Database.database(url: "https://hiddenmickeycyberspace-default-rtdb.firebaseio.com/").reference()
    
    func getParkAndRideLocationInformation() {
        var parkLocations: [HMCParkLocation] = []
        HMCRequestHandler.ref.child("locations").observe(.childAdded) { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            guard let parkName = postDict["parkName"] as? String,
                  let parkID = postDict["parkID"] as? String,
                  let centerPointLat = postDict["centerPointLat"] as? CLLocationDegrees,
                  let centerPointLon = postDict["centerPointLon"] as? CLLocationDegrees,
                  let radius = postDict["radius"] as? Int else {
                return
            }
            let newParkLocation = HMCParkLocation(parkName: parkName, parkID: parkID, centerPoint: CLLocationCoordinate2D(latitude: centerPointLat, longitude: centerPointLon), radius: radius)
            parkLocations.append(newParkLocation)
        }
        
    }
    
    func setParkAndRideLocationInformation() {
        let disneylandCaliforniaLocation = HMCParkLocation(parkName: "Disneyland", parkID: "disneylandCalifornia", centerPoint: CLLocationCoordinate2D(latitude: 33.8121, longitude:-117.9190), radius: 10)
        let splashMountainDisneylandCaliforniaLocation = HMCAttractionLocation(attractionName: "Splash Mountain Disneyland California", attractionID: "splashMountainDisneylandCalifornia", centerPoint: CLLocationCoordinate2D(latitude: 33.812204, longitude: -117.922804), radius: 2)
        disneylandCaliforniaLocation.attractions.append(splashMountainDisneylandCaliforniaLocation)
        
        setLocationData(parkLocation: disneylandCaliforniaLocation)
    }
    
    func setLocationData(parkLocation: HMCParkLocation) {
        HMCRequestHandler.ref.child("locations").child(parkLocation.parkID).child("parkName").setValue(parkLocation.parkName)
        HMCRequestHandler.ref.child("locations").child(parkLocation.parkID).child("parkID").setValue(parkLocation.parkID)
        HMCRequestHandler.ref.child("locations").child(parkLocation.parkID).child("centerPointLat").setValue(parkLocation.centerPoint.latitude)
        HMCRequestHandler.ref.child("locations").child(parkLocation.parkID).child("centerPointLon").setValue(parkLocation.centerPoint.longitude)
        HMCRequestHandler.ref.child("locations").child(parkLocation.parkID).child("radius").setValue(parkLocation.radius)
        
        for attraction in parkLocation.attractions {
            HMCRequestHandler.ref.child("locations").child(parkLocation.parkID).child("attractions").child(attraction.attractionID).child("attractionName").setValue(attraction.attractionName)
            HMCRequestHandler.ref.child("locations").child(parkLocation.parkID).child("attractions").child(attraction.attractionID).child("attractionID").setValue(attraction.attractionID)
            HMCRequestHandler.ref.child("locations").child(parkLocation.parkID).child("attractions").child(attraction.attractionID).child("centerPointLat").setValue(attraction.centerPoint.latitude)
            HMCRequestHandler.ref.child("locations").child(parkLocation.parkID).child("attractions").child(attraction.attractionID).child("centerPointLon").setValue(attraction.centerPoint.longitude)
            HMCRequestHandler.ref.child("locations").child(parkLocation.parkID).child("attractions").child(attraction.attractionID).child("radius").setValue(attraction.radius)
        }
        
    }
}
