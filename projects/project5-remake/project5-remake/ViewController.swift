//
//  ViewController.swift
//  project5-remake
//
//  Created by Mohammad Eid on 28/01/2024.
//

import UIKit

class ViewController: UITableViewController {
    var startingWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let wordsPath = Bundle.main.path(forResource: "start", ofType: "txt")!
        let contents = try! String(contentsOfFile: wordsPath)
        startingWords = contents.components(separatedBy: "\n")

        title = startingWords.randomElement()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshTapped))
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Answer", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }

    @objc func refreshTapped() {
        var indexPathes = [IndexPath]()

        for i in 0 ..< usedWords.count {
            indexPathes.append(IndexPath(row: i, section: 0))
        }

        usedWords.removeAll(keepingCapacity: true)
        tableView.deleteRows(at: indexPathes, with: .automatic)
        title = startingWords.randomElement()
       
    }

    @objc func addTapped() {
        let ac = UIAlertController(title: "Add Word", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Save", style: .default) { [weak self, weak ac] _ in
            if let answer = ac?.textFields?[0].text {
                self?.submit(answer)
            }
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }

    func submit(_ answer: String) {
        
        let lowAnswer = answer.lowercased()
        
        var errorTitle: String?
        var errorMessage: String?
        
        if !isLongEnough(lowAnswer) {
            errorTitle = "Too Short!"
            errorMessage = "Your word should be at least 3 letters long."
        } else if !isDifferent(lowAnswer) {
            errorTitle = "Same Word!"
            errorMessage = "Come up with your own words!"
        } else if !isPossible(lowAnswer) {
            errorTitle = "Wrong Word!"
            errorMessage = "You can't make this \(answer) from \(title ?? "given word")."
        } else if !isOriginal(lowAnswer) {
            errorTitle = "Word Already Used!"
            errorMessage = "Be more original!"
        } else if !isReal(lowAnswer) {
            errorTitle = "Word not Recognized!"
            errorMessage = "You can't make them up, you know."
        }
        
        if let errorTitle, let errorMessage {
            let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(ac, animated: true)
            return
        }
        
        usedWords.insert(answer, at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }

    func isLongEnough(_ answer: String) -> Bool {
        return answer.count >= 3
    }

    func isDifferent(_ answer: String) -> Bool {
        return answer != title
    }

    func isPossible(_ answer: String) -> Bool {
        guard var tempWord = title else {
            return false
        }

        for letter in answer {
            if let i = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: i)
            } else {
                return false
            }
        }

        return true
    }

    func isOriginal(_ answer: String) -> Bool {
        return !usedWords.contains(answer)
    }

    func isReal(_ answer: String) -> Bool {
        let checker = UITextChecker()
        let misspelled = checker.rangeOfMisspelledWord(in: answer, range: NSRange(location: 0, length: answer.utf16.count), startingAt: 0, wrap: false, language: "en")
        return misspelled.location == NSNotFound
    }
}
