//
//  HMCHomeMapViewController.swift
//  HiddenMickeyCyberspace
//
//  Created by Justin Rodriguez on 6/5/21.
//

import UIKit
import MapKit
import CoreLocation

class HMCHomeMapViewController: HMCViewController, CLLocationManagerDelegate {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var drawerView: UIView!
    @IBOutlet weak var centerButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    private var locationManager: CLLocationManager?
    private var aRViewController: HMCARCameraViewController?
    private var scoreViewController: HMCFinalScoreViewController?
    private var hasShownLocationErrorMessage: Bool = false
    private var rideMapAnnotations: [HMCPlace] = []
    
    let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 28.418706530474907, longitude: -81.58117684959575), latitudinalMeters: 10000, longitudinalMeters: 10000)
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMapView()
        configureDrawerView()
        
        let requestHandler = HMCRequestHandler()
        requestHandler.readParkLocationData { parks in
            disneyParkLocationsArray = parks
            requestHandler.readRides { rides in
                ridesArray = rides
                var newRidesTitleMap : [String : HMCRide] = [:]
                for ride in rides {
                    newRidesTitleMap[ride.rideID] = ride
                }
                titleRideMap = newRidesTitleMap
                self.configureMapView()
            }
        }
    }
    
    func configureMapView() {
        mapView.delegate = self
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.pointOfInterestFilter = .excludingAll
//        Causes errors on simulator
        let mapCamera = MKMapCamera(lookingAtCenter: CLLocationCoordinate2D(latitude: region.center.latitude, longitude: region.center.longitude), fromDistance: 500, pitch: 65, heading: 0)
        mapView.setCamera(mapCamera, animated: false)
        
        mapView.removeAnnotations(rideMapAnnotations)
        var rideAnnotations: [HMCPlace] = []
        for ride in ridesArray {
            rideAnnotations.append(ride.rideAnnotation)
            mapView.addAnnotation(ride.rideAnnotation)
        }
        rideMapAnnotations = rideAnnotations
        
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        
        if let username = UserDefaults.standard.string(forKey: usernameKey), username == natalieCheatCode || username == testerCheatCode {
            mapView.isZoomEnabled = true
            mapView.isScrollEnabled = true
            locationManager?.stopUpdatingLocation()
            mapView.showsUserLocation = false
        } else {
            locationManager?.startUpdatingLocation()
            mapView.showsUserLocation = true
            mapView.isZoomEnabled = false
            mapView.isScrollEnabled = false
        }
    }
    
    func configureDrawerView() {
        drawerView.layer.cornerRadius = 40
        drawerView.alpha = 0.97
        centerButton.layer.cornerRadius = 40
        centerButton.clipsToBounds = true
        rightButton.tintColor = HMCButtonColor1
        leftButton.tintColor = HMCButtonColor1
        centerButton.backgroundColor = HMCButtonColor1
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        let mapCamera = MKMapCamera(lookingAtCenter: currentLocation.coordinate, fromDistance: 500, pitch: 65, heading: 0)
        mapView.setCamera(mapCamera, animated: false)
        
        if !userIsNearDisneyPark(currentLocation: currentLocation.coordinate) && hasShownLocationErrorMessage == false {
            hasShownLocationErrorMessage = true
            let alert = UIAlertController(title: "Looks like you're not near any attractions", message: "You'll be able to collect hidden Easter eggs once you're near attractions. For now, you can play in quick play mode using the play button on the right.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func userIsNearDisneyPark(currentLocation: CLLocationCoordinate2D) -> Bool {
        var isNear: Bool = false
        for park in disneyParkLocationsArray {
            if distance(from: currentLocation, to: park.centerLocation) <= park.radius {
                isNear = true
            }
        }
        return isNear
    }
    
    func showPlayNowARView(ride: HMCRide?) {
        let viewController = HMCARCameraViewController()
        viewController.ride = ride
        viewController.delegate = self
        viewController.modalPresentationStyle = .fullScreen
        viewController.isModalInPresentation = false
        aRViewController = viewController
        present(viewController, animated: true, completion: nil)
    }
    
    func showMickeyCollectionView() {
        let viewController = HMCScoreAndCollectionViewController()
        present(viewController, animated: true, completion: nil)
    }
    
    func showProfileViewController() {
        let viewController = HMCProfileViewController()
        viewController.delegate = self
        present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func didTapRightButton(_ sender: Any) {
        showPlayNowARView(ride: nil)
    }
    
    @IBAction func didTapLeftButton(_ sender: Any) {
        showProfileViewController()
    }
    
    @IBAction func didTapCenterButton(_ sender: Any) {
        showMickeyCollectionView()
    }
    
    func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
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
    func didLeaveARView(score: Int, ride: HMCRide?) {
        aRViewController?.dismiss(animated: true, completion: {
            let viewController = HMCFinalScoreViewController()
            viewController.delegate = self
            viewController.ride = ride
            viewController.score = score
            self.present(viewController, animated: true, completion: nil)
            self.scoreViewController = viewController
        })
    }
}

extension HMCHomeMapViewController: HMCFinalScoreViewControllerDelegate {
    func didPressPlayAgain(ride: HMCRide?) {
        scoreViewController?.dismiss(animated: true, completion: {
            self.showPlayNowARView(ride: ride)
        })
    }
}

extension HMCHomeMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is MKUserLocation {
            return
        }
        
        mapView.deselectAnnotation(view.annotation, animated: true)
        let viewController = HMCMapCalloutViewController()
        guard let rideTitle : String = view.annotation?.title ?? "Generic", let ride = titleRideMap[rideTitle] else {
            return
        }
        viewController.delegate = self
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        present(viewController, animated: true, completion: {
            viewController.configure(ride: ride)
        })
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let rideTitle: String? = view.annotation?.title, let ride = titleRideMap[rideTitle ?? "Generic"] {
            showPlayNowARView(ride: ride)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            print("UUUuser location")
            return nil
        }
        
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) else {
            return nil
        }
        
        let pinImage = UIImage(named: "magic-wand")
        let size = CGSize(width: 32, height: 32)
        UIGraphicsBeginImageContext(size)
        pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        annotationView.image = resizedImage
        annotationView.canShowCallout = false
        return annotationView
    }
}

extension HMCHomeMapViewController : HMCMapCalloutViewControllerDelegate {
    func playRide(ride: HMCRide) {
        showPlayNowARView(ride: ride)
    }
}

extension HMCHomeMapViewController : HMCProfileViewControllerDelegate {
    func didUpdateUsername() {
        self.configureMapView()
    }
}
