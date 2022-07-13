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

    func writeRides() {
        for ride in ridesArray {
            HMCRequestHandler.ref.child("rides").child(ride.rideID).child("title").setValue(ride.title)
            HMCRequestHandler.ref.child("rides").child(ride.rideID).child("latitude").setValue(ride.rideAnnotation.coordinate.latitude)
            HMCRequestHandler.ref.child("rides").child(ride.rideID).child("longitude").setValue(ride.rideAnnotation.coordinate.longitude)
            HMCRequestHandler.ref.child("rides").child(ride.rideID).child("earColor").setValue(ride.colors.earColor.hexString)
            HMCRequestHandler.ref.child("rides").child(ride.rideID).child("headColor").setValue(ride.colors.headColor.hexString)
            HMCRequestHandler.ref.child("rides").child(ride.rideID).child("earBorderColor").setValue(ride.colors.earBorderColor?.hexString)
            HMCRequestHandler.ref.child("rides").child(ride.rideID).child("headBorderColor").setValue(ride.colors.headBorderColor?.hexString)
            HMCRequestHandler.ref.child("rides").child(ride.rideID).child("isPremiumRide").setValue(ride.isPremiumRide)
            HMCRequestHandler.ref.child("rides").child(ride.rideID).child("park").setValue(ride.park)
            HMCRequestHandler.ref.child("rides").child(ride.rideID).child("difficulty").setValue(ride.difficulty)
        }
    }
    
    func readRides(completion: @escaping ([HMCRide])->Void) {
        var newRidesArray: [HMCRide] = []
        DispatchQueue.global(qos: .background).async {
            HMCRequestHandler.ref.child("rides").observeSingleEvent(of: .value) { (snapshot) in
                for case let child as DataSnapshot in snapshot.children {
                    if let rideDict = child.value as? [String: AnyObject] {
                        guard let title = rideDict["title"] as? String,
                              let latitude = rideDict["latitude"] as? CGFloat,
                              let longitude = rideDict["longitude"] as? CGFloat,
                              let earColor = rideDict["earColor"] as? String,
                              let headColor = rideDict["headColor"] as? String,
                              let earBorderColor = rideDict["earBorderColor"] as? String?,
                              let headBorderColor = rideDict["headBorderColor"] as? String?,
                              let isPremiumRide = rideDict["isPremiumRide"] as? Bool,
                              let difficulty = rideDict["difficulty"] as? Int,
                              let park = rideDict["park"] as? String else {
                            return
                        }
                        
                        guard let uiHeadColor = UIColor(hex: headColor),
                              let uiEarColor = UIColor(hex: earColor) else {
                            return
                        }
                        let ride = HMCRide(title: title,
                                           coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                                           isPremiumRide: isPremiumRide,
                                           difficulty: difficulty,
                                           park: park,
                                           headColor: uiHeadColor,
                                           earColor: uiEarColor,
                                           headBorderColor: UIColor(hex: headBorderColor ?? ""),
                                           earBorderColor: UIColor(hex: earBorderColor ?? ""))
                        newRidesArray.append(ride)
                    }
                }
                completion(newRidesArray)
            }
        }
    }
    
    func writeParkLocationData() {
        for park in disneyParkLocationsArray {
            HMCRequestHandler.ref.child("parks").child(park.id).child("id").setValue(park.id)
            HMCRequestHandler.ref.child("parks").child(park.id).child("latitude").setValue(park.centerLocation.latitude)
            HMCRequestHandler.ref.child("parks").child(park.id).child("longitude").setValue(park.centerLocation.longitude)
            HMCRequestHandler.ref.child("parks").child(park.id).child("radius").setValue(park.radius)
            
        }
    }
    
    func readParkLocationData(completion: @escaping ([HMCDisneyPark])->Void) {
        var parks: [HMCDisneyPark] = []
        DispatchQueue.global(qos: .background).async {
            HMCRequestHandler.ref.child("parks").observeSingleEvent(of: .value) { (snapshot) in
                for case let child as DataSnapshot in snapshot.children {
                    if let parkDict = child.value as? [String: AnyObject] {
                        guard let id = parkDict["id"] as? String,
                              let latitude = parkDict["latitude"] as? CGFloat,
                              let longitude = parkDict["longitude"] as? CGFloat,
                              let radius = parkDict["radius"] as? CGFloat else {
                            return
                        }
                        
                        let park = HMCDisneyPark(id: id, centerLocation: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), radius: radius)
                        parks.append(park)
                    }
                }
                completion(parks)
            }
        }
    }
    
    func readProfileTabConfig(completion : @escaping ()->Void) {
        DispatchQueue.global(qos: .background).async {
            HMCRequestHandler.ref.child("config").observeSingleEvent(of: .value) { snapshot in
                if let configDict = snapshot.value as? [String : AnyObject] {
                    guard let isUnlockButtonEnabledRead = configDict["isUnlockButtonEnabled"] as? Bool,
                          let unlockRidesAlertButtonRead = configDict["unlockRidesAlertButton"] as? String,
                          let unlockRidesAlertMessageRead = configDict["unlockRidesAlertMessage"] as? String else {
                        return
                    }
                    isUnlockButtonEnabled = isUnlockButtonEnabledRead
                    unlockRidesAlertButton = unlockRidesAlertButtonRead
                    unlockRidesAlertMessage = unlockRidesAlertMessageRead
                    completion()
                }
            }
        }
    }
}
