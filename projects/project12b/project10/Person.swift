//
//  Person.swift
//  project10
//
//  Created by Mohammad Eid on 02/02/2024.
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
