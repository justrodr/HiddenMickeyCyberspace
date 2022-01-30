//
//  CustomAnnotationView.swift
//  HiddenMickeyCyberspace
//
//  Created by Justin Rodriguez on 1/29/22.
//

import UIKit
import MapKit

class CustomAnnotationView: MKPinAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        canShowCallout = true
        rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        configureDetailView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureDetailView() {
        guard let annotation = annotation else { return }

        let rect = CGRect(origin: .zero, size: CGSize(width: 300, height: 200))

        let snapshotView = UIView()
        snapshotView.translatesAutoresizingMaskIntoConstraints = false

        let options = MKMapSnapshotter.Options()
        options.size = rect.size
        options.mapType = .satelliteFlyover
        options.camera = MKMapCamera(lookingAtCenter: annotation.coordinate, fromDistance: 250, pitch: 65, heading: 0)

        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                print(error ?? "Unknown error")
                return
            }

            let imageView = UIImageView(frame: rect)
            imageView.image = snapshot.image
            snapshotView.addSubview(imageView)
        }

        detailCalloutAccessoryView = snapshotView
        NSLayoutConstraint.activate([
            snapshotView.widthAnchor.constraint(equalToConstant: rect.width),
            snapshotView.heightAnchor.constraint(equalToConstant: rect.height)
        ])
    }
}
