//
//  Capitals.swift
//  project16
//
//  Created by Mohammad Eid on 12/02/2024.
//

import Foundation
import MapKit

struct Capitals {
    static let capitals = [london, oslo, paris, rome, washington]
    static let london = Capital(
        title: "London",
        coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
        info: "Home to the 2012 Summer Olympics.",
        wikiPage: URL(string: "https://en.wikipedia.org/wiki/London")!
    )
    static let oslo = Capital(
        title: "Oslo",
        coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75),
        info: "Founded over a thousand years ago.",
        wikiPage: URL(string: "https://en.wikipedia.org/wiki/Oslo")!
    )
    static let paris = Capital(
        title: "Paris",
        coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508),
        info: "Often called the City of Light.",
        wikiPage: URL(string: "https://en.wikipedia.org/wiki/Paris")!
    )
    static let rome = Capital(
        title: "Rome",
        coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5),
        info: "Has a whole country inside it.",
        wikiPage: URL(string: "https://en.wikipedia.org/wiki/Rome")!
    )
    static let washington = Capital(
        title: "Washington DC",
        coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667),
        info: "Named after George himself.",
        wikiPage: URL(string: "https://en.wikipedia.org/wiki/Washington,_D.C.")!
    )
}
