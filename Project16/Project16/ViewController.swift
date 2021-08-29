//
//  ViewController.swift
//  Project16
//
//  Created by out-usacheva-ei on 28.08.2021.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Awesome Map"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "View", style: .plain, target: self, action: #selector(viewChange))
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), wiki: "https://en.wikipedia.org/wiki/London")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), wiki: "https://en.wikipedia.org/wiki/Oslo")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), wiki: "https://en.wikipedia.org/wiki/Paris")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), wiki: "https://en.wikipedia.org/wiki/Rome")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), wiki: "https://en.wikipedia.org/wiki/Washington,_D.C.")
        
        mapView.addAnnotations([london, oslo, paris, rome, washington])
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.pinTintColor = UIColor.systemIndigo
            
            let button = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = button
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        
//        let placeName = capital.title
//        let placeInfo = capital.info
        
//        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default))
//        present(ac, animated: true)
        
        let vc = WikiViewController()
        vc.capitalName = capital.title
        vc.urlString = capital.wiki
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func viewChange() {
        let ac = UIAlertController(title: "Select view", message: nil, preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "Standart", style: .default, handler: { action in
            self.mapView.mapType = .standard
        }))
        ac.addAction(UIAlertAction(title: "Satellite", style: .default, handler: { action in
            self.mapView.mapType = .satellite
        }))
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: { action in
            self.mapView.mapType = .hybrid
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }

}

