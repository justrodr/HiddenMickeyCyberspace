//
//  HMCHomeMapViewController.swift
//  HiddenMickeyCyberspace
//
//  Created by Justin Rodriguez on 6/5/21.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class HMCHomeMapViewController: HMCViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    private var locationManager: CLLocationManager?
    private var locationProximityModel: HMCLocationProximityModel
    private var aRViewController: HMCARCameraViewController?
    
    let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 28.418706530474907, longitude: -81.58117684959575), latitudinalMeters: 10000, longitudinalMeters: 10000)
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        locationProximityModel = HMCLocationProximityModel()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        let mapCamera = MKMapCamera(lookingAtCenter: CLLocationCoordinate2D(latitude: region.center.latitude, longitude: region.center.longitude), fromDistance: 500, pitch: 65, heading: 0)
        mapView.setCamera(mapCamera, animated: false)
        mapView.addAnnotation(buzzLightyearRide)
        
//        locationManager = CLLocationManager()
//        locationManager?.delegate = self
//        locationManager?.requestAlwaysAuthorization()
//        locationManager?.startUpdatingLocation()
//        mapView.showsUserLocation = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        let mapCamera = MKMapCamera(lookingAtCenter: currentLocation.coordinate, fromDistance: 500, pitch: 65, heading: 0)
        mapView.setCamera(mapCamera, animated: false)
    }
    
    func showPlayNowARView(title: String?) {
        let viewController = HMCARCameraViewController()
        if let title = title, let colors = colorMapping[title] {
            viewController.mickeyHeadColor = colors.headColor
            viewController.mickeyEarColor = colors.earColor
        }
        viewController.delegate = self
        viewController.modalPresentationStyle = .fullScreen
        viewController.isModalInPresentation = false
        aRViewController = viewController
        present(viewController, animated: true, completion: nil)
    }

}

//extension HMCHomeMapViewController: HMCHomeProfileDrawerViewControllerDelegate {
//    func showPlayNowARView() {
//        let viewController = HMCARCameraViewController()
//        viewController.delegate = self
//        viewController.modalPresentationStyle = .fullScreen
//        viewController.isModalInPresentation = false
//        ARViewController = viewController
//        present(viewController, animated: true, completion: nil)
//    }
//}

extension HMCHomeMapViewController: HMCARCameraViewControllerDelegate {
    func didLeaveARView(score: Int) {
        aRViewController?.dismiss(animated: true, completion: {
            let viewController = HMCFinalScoreViewController()
            self.present(viewController, animated: true, completion: nil)
            viewController.setScore(score: score)
        })
    }
}

extension HMCHomeMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("select")
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("tapped")
        if let rideTitle: String? = view.annotation?.title {
            showPlayNowARView(title: rideTitle)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) else {
            print("bummer")
            return nil
        }
        print("cool")
        return annotationView
    }
}
