//
//  NoteViewController.swift
//  milestone-project7
//
//  Created by Mohammad Eid on 21/02/2024.
//

import UIKit

class NoteViewController: UIViewController, UITextFieldDelegate {
    var note: Note!

    var saveDelegate: NoteStorageDelegate?

    @IBOutlet var titleField: UITextField!
    @IBOutlet var contentField: UITextView!
    
    var deleting = false

    override func viewDidLoad() {
        super.viewDidLoad()
        assert(note != nil, "No note provided!")

        titleField.text = note.title
        contentField.text = note.content

        titleField.delegate = self

        navigationItem.largeTitleDisplayMode = .never

        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .trash, primaryAction: UIAction { [weak self] _ in self?.handleDelete() })

        NotificationCenter.default.addObserver(self, selector: #selector(handleGoinToBackground), name: UIApplication.willResignActiveNotification, object: nil)
    }

    func handleDelete() {
        let ac = UIAlertController(title: "Delete Note", message: "Are you sure you want to delete this note?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let self else { return }
            self.saveDelegate?.deleteNote(self.note)
            deleting = true
            self.navigationController?.popViewController(animated: true)
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleField {
            textField.resignFirstResponder()
            contentField.becomeFirstResponder()
        }

        return true
    }

    override func viewWillDisappear(_ animated: Bool) {
        if !deleting {
            saveNote()
        }
    }

    @objc func handleGoinToBackground() {
        saveNote()
    }

    func saveNote() {
        note.title = titleField.text ?? ""
        note.content = contentField.text
        saveDelegate?.saveNote(note)
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}
