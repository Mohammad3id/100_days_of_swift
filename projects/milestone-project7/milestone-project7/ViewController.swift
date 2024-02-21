//
//  ViewController.swift
//  milestone-project7
//
//  Created by Mohammad Eid on 21/02/2024.
//

import UIKit

class ViewController: UITableViewController, NoteStorageDelegate {
    var notes = [Note]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "My Notes"
        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            systemItem: .compose,
            primaryAction: UIAction { [weak self] _ in self?.handleCreateNote() }
        )

        loadNotes()
    }

    override func viewWillDisappear(_ animated: Bool) {
        saveNotes()
    }

    func handleCreateNote() {
        let note = Note(id: UUID(), title: "", content: "")
        let vc = navigationController?.storyboard?.instantiateViewController(withIdentifier: "NoteViewController") as! NoteViewController
        vc.note = note
        vc.saveDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }

    func loadNotes() {
        let documentsPath = getDocumentsDirectory()
        let notesPath = documentsPath.appendingPathComponent("notes.json")

        let jsonData: Data

        do {
            jsonData = try Data(contentsOf: notesPath)
        } catch {
            print("Couldn't find file")
            print(error)
            return
        }

        do {
            let decoder = JSONDecoder()
            let decodedNotes = try decoder.decode(Notes.self, from: jsonData)
            notes = decodedNotes.notes
            tableView.reloadData()
        } catch {
            print("Couldn't decode data")
            print(error)
        }
    }

    func saveNotes() {
        let documentsPath = getDocumentsDirectory()
        let notesPath = documentsPath.appendingPathComponent("notes.json")

        let notes = Notes(notes: notes)
        let encoder = JSONEncoder()

        let encodedData: Data
        do {
            encodedData = try encoder.encode(notes)
        } catch {
            print("Couldn't encode data")
            print(error)
            return
        }

        do {
            try encodedData.write(to: notesPath)
        } catch {
            print("Couldn't save data")
            print(error)
        }
    }

    func saveNote(_ note: Note) {
        if let noteIndex = notes.firstIndex(where: { noteInstance in noteInstance.id == note.id }) {
            notes[noteIndex] = note
            tableView.reloadData()
        } else {
            notes.insert(note, at: 0)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            }
        }
        saveNotes()
    }

    func deleteNote(_ note: Note) {
        if let noteIndex = notes.firstIndex(where: { noteInstance in noteInstance.id == note.id }) {
            notes.remove(at: noteIndex)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
                self.tableView.deleteRows(at: [IndexPath(row: noteIndex, section: 0)], with: .automatic)
            }
            saveNotes()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        let note = notes[indexPath.row]

        var config = cell.defaultContentConfiguration()
        config.text = if note.title.isEmpty { "New Note" } else { note.title }
        config.secondaryText = note.content
        cell.contentConfiguration = config

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = notes[indexPath.row]
        let vc = navigationController?.storyboard?.instantiateViewController(withIdentifier: "NoteViewController") as! NoteViewController
        vc.note = note
        vc.saveDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
