//
//  ViewController.swift
//  project5
//
//  Created by Mohammad Eid on 26/01/2024.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))

        if let startWordsUrl = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsUrl) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }

        if allWords.isEmpty {
            allWords = ["slikworm"]
        }
        
        let defaults = UserDefaults.standard
        
        if let savedCrrentWord = defaults.string(forKey: "currentWord"), let savedUsedWords = defaults.stringArray(forKey: "usedWords") {
            title = savedCrrentWord
            usedWords = savedUsedWords
            tableView.reloadData()
        } else {
            startGame()
        }
        
    }

    @objc func startGame() {
        title = allWords.randomElement()
    
        let defaults = UserDefaults.standard
        defaults.setValue(title ?? "", forKey: "currentWord")
        
        var indexPathes = [IndexPath]()
        for i in 0..<usedWords.count {
            indexPathes.append(IndexPath(row: i, section: 0))
        }
        usedWords.removeAll(keepingCapacity: true)
        tableView.deleteRows(at: indexPathes, with: .automatic)
        
        defaults.setValue(usedWords, forKey: "usedWords")
    }

    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter Answer", message: nil, preferredStyle: .alert)
        
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        var errorTitle: String?
        var errorMessage: String?
        
        if !isNew(word: lowerAnswer) {
            errorTitle = "Word isn't new"
            errorMessage = "Come up with your own words!"
        } else if !isPossible(word: lowerAnswer) {
            guard let title = title?.lowercased() else { return }
            errorTitle = "Word not possible"
            errorMessage = "You can't spell that word from \(title)"
        } else if !isLongEnough(word: lowerAnswer) {
            errorTitle = "Word too short"
            errorMessage = "Your word should be at least 3 letters long"
        } else if !isOriginal(word: lowerAnswer) {
            errorTitle = "Word used already"
            errorMessage = "Be more original!"
        } else if !isReal(word: lowerAnswer) {
            errorTitle = "Word not recognised"
            errorMessage = "You can't just make them up, you know!"
        }
        
        if let errorTitle, let errorMessage {
            showErrorAlert(errorTitle, errorMessage)
            return
        }
        
        usedWords.insert(lowerAnswer, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        UserDefaults.standard.setValue(usedWords, forKey: "usedWords")
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }

    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }

    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func isLongEnough(word: String) -> Bool {
        return word.count >= 3
    }
    
    func isNew(word: String) -> Bool {
        return title != word
    }
    
    func showErrorAlert(_ title: String, _ message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
}
