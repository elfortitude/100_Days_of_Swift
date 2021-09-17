//
//  ViewController.swift
//  Project22
//
//  Created by out-usacheva-ei on 13.09.2021.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var distanceReading: UILabel!
    @IBOutlet weak var currentBeacon: UILabel!
    
//      This is the Core Location class that lets us configure how we want to be
//      notified about location, and will also deliver location updates to us.
    var locationManager: CLLocationManager?
    var wasFound: Bool = false
    var uuids = ["5A4BCFCE-174E-4BAC-A814-092E77F6B7E5", "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0", "74278BDA-B644-4520-8F0C-720EAF059935"]
    
    var circle: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
//      Set self delegate for observing distance changing.
        locationManager?.delegate = self
//        Authorization request.
        locationManager?.requestAlwaysAuthorization()
        
//      Settings for circle like view.
        circle = UIView(frame: CGRect(x: 0, y: 0, width: 256, height: 256))
        circle.center.x = view.center.x
        circle.center.y = view.center.y - 20
        circle.backgroundColor = UIColor.black
        circle.alpha = 0.5
        circle.layer.cornerRadius = 128
        view.addSubview(circle!)
        
        view.backgroundColor = .gray
    }

//      Launching scanning when user allowed monitoring location request.
//      The method that will be called when the user has finally made their mind.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning(uuid: UUID(uuidString: uuids[0])!, major: 123, minor: 456, identifier: "MyBeacon1")
                    startScanning(uuid: UUID(uuidString: uuids[1])!, major: 123, minor: 456, identifier: "MyBeacon2")
                    startScanning(uuid: UUID(uuidString: uuids[2])!, major: 123, minor: 456, identifier: "MyBeacon3")
                }
            }
        }
    }
    
//      Get all detected beacons, select first and launching update method.
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        for beacon in beacons {
//        if let beacon = beacons.first {
            update(distance: beacon.proximity, name: region.identifier)
//        } else {
//            update(distance: .unknown, name: "BEACON")
//        }
        }
    }
    
//      Monitoring three other beacons and calculating ranging to them.
//      CLBeaconRegion is used to identify a beacon uniquely.
    func startScanning(uuid: UUID, major: UInt16, minor: UInt16, identifier: String) {
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: major, minor: minor, identifier: identifier)
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
    }
    
    func update(distance: CLProximity, name: String) {
        UIView.animate(withDuration: 1) {
            self.currentBeacon.text = name
            switch distance {
            case .far:
                self.view.backgroundColor = UIColor.blue
                self.distanceReading.text = "FAR"
                self.circle.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
            case .near:
                self.view.backgroundColor = UIColor.orange
                self.distanceReading.text = "NEAR"
                self.circle.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            case .immediate:
                self.view.backgroundColor = UIColor.red
                self.distanceReading.text = "RIGHT HERE"
                self.circle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.wasFound = true
                if (!self.wasFound) {
                    let ac = UIAlertController(title: "Your beacon is here!", message: nil, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated: true)
                }
            default:
                self.view.backgroundColor = UIColor.gray
                self.distanceReading.text = "UNKNOWN"
                self.currentBeacon.text = "BEACON"
                self.circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            }
        }
    }
}

