//
//  Note.swift
//  milestone-project7
//
//  Created by Mohammad Eid on 21/02/2024.
//

import Foundation

struct Note: Codable, Identifiable {
    var id: UUID
    var title: String
    var content: String
}
