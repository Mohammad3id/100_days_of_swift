//
//  ViewController.swift
//  project22
//
//  Created by Mohammad Eid on 21/02/2024.
//

import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var beaconLabel: UILabel!
    @IBOutlet var indicator: UIView!
    
    var locationManager: CLLocationManager?
    
    var detected = false
    
    let beacons = [
        CLBeaconRegion(uuid: UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!, major: 123, minor: 456, identifier: "Beacon 1"),
        CLBeaconRegion(uuid: UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!, major: 123, minor: 457, identifier: "Beacon 2"),
        CLBeaconRegion(uuid: UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!, major: 123, minor: 458, identifier: "Beacon 3")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()

        view.backgroundColor = .gray
        beaconLabel.text = ""
        
        indicator.layer.cornerRadius = indicator.frame.width / 2
        indicator.layer.backgroundColor = UIColor.white.withAlphaComponent(0.25).cgColor
        indicator.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        var i = 0
        var proxemities: [CLProximity] = [.far, .near, .immediate, .unknown]
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) {[weak self] _ in
            let proxemity = proxemities[i]
            i = (i + 1) % proxemities.count
            self?.update(distance: proxemity)
        }
        
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeacon.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        if let beacon = beacons.first {
            if !detected {
                detected = true
                let ac = UIAlertController(title: "Beacon Detected!", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
            update(distance: beacon.proximity)
            let region = self.beacons.first { region in region.minor == beacon.minor }
            self.beaconLabel.text = region?.identifier ?? "UNKNOWN"
        } else {
            detected = false
            update(distance: .unknown)
            self.beaconLabel.text = ""
        }
    }

    func startScanning() {
        for beacon in beacons {
            locationManager?.startMonitoring(for: beacon)
            locationManager?.startRangingBeacons(satisfying: beacon.beaconIdentityConstraint)
        }
    }

    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            switch distance {
            case .unknown:
                self.view.backgroundColor = UIColor.gray
                self.distanceReading.text = "UNKNOWN"
                self.indicator.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            case .far:
                self.view.backgroundColor = UIColor.systemBlue
                self.distanceReading.text = "FAR"
                self.indicator.transform = CGAffineTransform(scaleX: 1, y: 1)

            case .near:
                self.view.backgroundColor = UIColor.systemOrange
                self.distanceReading.text = "NEAR"
                self.indicator.transform = CGAffineTransform(scaleX: 2, y: 2)

            case .immediate:
                self.view.backgroundColor = UIColor.systemRed
                self.distanceReading.text = "RIGHT HERE"
                self.indicator.transform = CGAffineTransform(scaleX: 5, y: 5)
                
            @unknown default:
                self.view.backgroundColor = .black
                self.distanceReading.text = "WHOA!"
            }
        }
    }
}
