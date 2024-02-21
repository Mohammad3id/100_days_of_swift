//
//  SaveDelegate.swift
//  milestone-project7
//
//  Created by Mohammad Eid on 21/02/2024.
//

import Foundation

protocol NoteStorageDelegate {
    func saveNote(_ note: Note)
    func deleteNote(_ note: Note)
}
