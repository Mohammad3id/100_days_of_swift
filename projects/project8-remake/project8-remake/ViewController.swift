//
//  ViewController.swift
//  project8-remake
//
//  Created by Mohammad Eid on 02/02/2024.
//

import UIKit

class ViewController: UIViewController {

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var scoreLabel = UILabel()
    
    let maxLevel = 4
    var level = 0 {
        didSet {
            levelLabel.text = "Level: \(level)"
        }
    }
    var levelLabel = UILabel()
    
    var clues = [String]() {
        didSet {
            cluesLabel.text = clues.joined(separator: "\n")
        }
    }
    var cluesLabel = UILabel()
    
    var guessedAnswers = 0
    var answers = [String]()
    var displayedAnswers = [String]() {
        didSet {
            answersLabel.text = displayedAnswers.joined(separator: "\n")
        }
    }
    var answersLabel = UILabel()
    
    var currentAnswer = "" {
        didSet {
            currentAnswerField.text = currentAnswer
        }
    }
    var currentAnswerField = UITextField()
    
    var wordPartButtons = [UIButton]()
    var usedWordPartButtons = [UIButton]()
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.white
        
        let submitButton = UIButton(type: .system)
        let clearButton = UIButton(type: .system)
        let buttonsView = UIView()
        
        for subView in [scoreLabel, levelLabel, cluesLabel, answersLabel, currentAnswerField, submitButton, clearButton, buttonsView] {
            subView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subView)
        }
        
        currentAnswerField.placeholder = "Tap letters to guess"
        currentAnswerField.font = UIFont.systemFont(ofSize: 48)
        
        submitButton.setTitle("Submit", for: .normal)
        submitButton.addTarget(self, action: #selector(wordSubmitted), for: .touchUpInside)
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        
        clearButton.setTitle("Clear", for: .normal)
        clearButton.addTarget(self, action: #selector(wordCleared), for: .touchUpInside)
        clearButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        
        currentAnswerField.isUserInteractionEnabled = false
        currentAnswerField.textAlignment = .center
        
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        cluesLabel.numberOfLines = 0
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        answersLabel.numberOfLines = 0
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.textAlignment = .right
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            levelLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            levelLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            
            cluesLabel.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 20),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            answersLabel.topAnchor.constraint(equalTo: cluesLabel.topAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            
            currentAnswerField.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            currentAnswerField.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            
            clearButton.topAnchor.constraint(equalTo: currentAnswerField.bottomAnchor, constant: 20),
            clearButton.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor, constant: 100),
            
            submitButton.topAnchor.constraint(equalTo: currentAnswerField.bottomAnchor, constant: 20),
            submitButton.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor, constant: -100),
            
            buttonsView.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            buttonsView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
        ])
        
        let buttonWidth = 150
        let buttonHeight = 80
        
        for row in 0 ..< 4 {
            for col in 0 ..< 5 {
                let button = UIButton(type: .system)
                button.addTarget(self, action: #selector(wordPartTapped), for: .touchUpInside)
                button.frame = CGRect(x: col * buttonWidth, y: row * buttonHeight, width: buttonWidth, height: buttonHeight)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
                wordPartButtons.append(button)
                buttonsView.addSubview(button)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        score = 0
        loadNextLevel()
    }
    
    @objc func wordPartTapped(_ button: UIButton) {
        guard let wordPart = button.titleLabel?.text else { return }
        button.isHidden = true
        usedWordPartButtons.append(button)
        
        currentAnswer += wordPart
    }

    @objc func wordSubmitted() {
        if let index = answers.firstIndex(of: currentAnswer) {
            score += 1
            guessedAnswers += 1
            currentAnswer = ""
            usedWordPartButtons.removeAll()
            
            var newDisplayedAnswers = displayedAnswers
            newDisplayedAnswers[index] = answers[index]
            displayedAnswers = newDisplayedAnswers
            
            if guessedAnswers == 7 {
                if level == maxLevel {
                    finishGame()
                } else {
                    finishLevel()
                }
            }
            
        } else {
            let ac = UIAlertController(title: "Wrong!", message: "Your answer doesn't match any of the clues!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default) { [weak self] _ in
                self?.score -= 1
                self?.wordCleared()
            })
            present(ac, animated: true)
        }
    }
    
    func finishLevel() {
        let ac = UIAlertController(title: "Well done!", message: "Level completed.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default) { [weak self] _ in
            self?.loadNextLevel()
        })
        present(ac, animated: true)
    }
    
    func finishGame() {
        let ac = UIAlertController(title: "All levels completed!", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Play Again", style: .default) { [weak self] _ in
            self?.level = 0
            self?.score = 0
            self?.loadNextLevel()
        })
        present(ac, animated: true)
    }
    
    @objc func wordCleared() {
        for button in usedWordPartButtons {
            button.isHidden = false
        }
        usedWordPartButtons.removeAll()
        currentAnswer = ""
    }
    
    func loadNextLevel() {
        guessedAnswers = 0
        level += 1
        
        if let url = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let content = try? String(contentsOf: url) {
                var lines = content.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n")
                lines.shuffle()
                
                var clues = [String]()
                var answers = [String]()
                var answerParts = [String]()
                
                for line in lines {
                    let parts = line.components(separatedBy: ": ")
                    let wordParts = parts[0]
                    let word = wordParts.replacingOccurrences(of: "|", with: "")
                    let clue = parts[1]
                    
                    clues.append(clue)
                    answers.append(word)
                    answerParts += wordParts.components(separatedBy: "|")
                }
                
                
                answerParts.shuffle()
                self.clues = clues
                self.answers = answers
                self.displayedAnswers = answers.map { answer in
                    "\(answer.count) letters"
                }
                
                for (index, part) in answerParts.enumerated() {
                    wordPartButtons[index].setTitle(part, for: .normal)
                    wordPartButtons[index].isHidden = false
                }
            }
        }
    }
}

