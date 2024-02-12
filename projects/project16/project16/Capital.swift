//
//  Capital.swift
//  project16
//
//  Created by Mohammad Eid on 12/02/2024.
//

import UIKit
import MapKit


class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    var wikiPage: URL
 
    init(title: String? = nil, coordinate: CLLocationCoordinate2D, info: String, wikiPage: URL) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
        self.wikiPage = wikiPage
    }
    
}
