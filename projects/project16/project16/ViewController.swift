//
//  ViewController.swift
//  project16
//
//  Created by Mohammad Eid on 12/02/2024.
//

import MapKit
import UIKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        title = "Capitals"

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Map Type", style: .plain, target: self, action: #selector(changeMapType))

        mapView.addAnnotations(Capitals.capitals)
    }

    @objc func changeMapType() {
        let ac = UIAlertController(title: "Change map type", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Standard", style: .default) { [weak self] _ in
            self?.mapView.mapType = .standard
        })
        ac.addAction(UIAlertAction(title: "Satellite", style: .default) { [weak self] _ in
            self?.mapView.mapType = .satellite
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }

        let identifier = "Capital"

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

        if annotationView == nil {
//            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)

            annotationView?.canShowCallout = true

            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }

        annotationView?.markerTintColor = UIColor.blue
        return annotationView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }

        let ac = UIAlertController(title: capital.title, message: capital.info, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Show wiki page", style: .default) { [weak self] _ in
            self?.showWiki(of: capital)
        })
        ac.addAction(UIAlertAction(title: "Close", style: .default))
        present(ac, animated: true)
    }
    
    func showWiki(of capital: Capital) {
        let wikiVC = WikiViewController()
        wikiVC.capital = capital
        navigationController?.pushViewController(wikiVC, animated: true)
    }
}
