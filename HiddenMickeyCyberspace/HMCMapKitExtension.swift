//
//  HMCMapKitExtension.swift
//  HiddenMickeyCyberspace
//
//  Created by Justin Rodriguez on 6/5/21.
//

import Foundation
import MapKit

extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}
