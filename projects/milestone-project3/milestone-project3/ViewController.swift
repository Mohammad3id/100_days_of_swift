//
//  ViewController.swift
//  milestone-project3
//
//  Created by Mohammad Eid on 01/02/2024.
//

import UIKit

class ViewController: UIViewController {
    let alphabet = [
        "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
        "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
    ]

    var scoreLabel = UILabel()
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }

    var levelLabel = UILabel()
    var level = 0 {
        didSet {
            levelLabel.text = "Level: \(level)"
        }
    }

    var guessedLettersLabel = UILabel()
    var guessedLetters = [String]() {
        didSet {
            guessedLettersLabel.text = guessedLetters.joined(separator: " ")
        }
    }

    var currentWord = [String]() {
        didSet {
            guessedLetters = (0 ..< currentWord.count).map { _ in
                "_"
            }
        }
    }

    var livesLeftLabel = UILabel()
    var livesLeft = 7 {
        didSet {
            livesLeftLabel.text = "Lives Left: \(livesLeft)"
        }
    }

    var alphabetButtons = [UIButton]()
    var usedLetters = [String]()
    var words = [String]()

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.white

        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        view.addSubview(scoreLabel)

        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.textAlignment = .left
        view.addSubview(levelLabel)

        guessedLettersLabel.translatesAutoresizingMaskIntoConstraints = false
        guessedLettersLabel.font = UIFont.systemFont(ofSize: 50)

        livesLeft = 7
        livesLeftLabel.translatesAutoresizingMaskIntoConstraints = false

        let lettersAndLivesView = UIView()
        lettersAndLivesView.translatesAutoresizingMaskIntoConstraints = false
        lettersAndLivesView.addSubview(guessedLettersLabel)
        lettersAndLivesView.addSubview(livesLeftLabel)
        lettersAndLivesView.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(lettersAndLivesView)

        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)

        let buttonWidth = 50
        let buttonHeight = 40

        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),

            levelLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            levelLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),

            lettersAndLivesView.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 20),
            lettersAndLivesView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            guessedLettersLabel.centerXAnchor.constraint(equalTo: lettersAndLivesView.centerXAnchor),
            guessedLettersLabel.centerYAnchor.constraint(equalTo: lettersAndLivesView.centerYAnchor, constant: -20),
            livesLeftLabel.topAnchor.constraint(equalTo: guessedLettersLabel.bottomAnchor, constant: 20),
            livesLeftLabel.centerXAnchor.constraint(equalTo: guessedLettersLabel.centerXAnchor),

            buttonsView.topAnchor.constraint(equalTo: lettersAndLivesView.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            buttonsView.widthAnchor.constraint(equalToConstant: CGFloat(buttonWidth) * 7),
            buttonsView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            buttonsView.heightAnchor.constraint(equalToConstant: CGFloat(buttonHeight) * 4),
        ])

        var offset = 0
        for i in 0 ... 3 {
            for j in 0 ... 6 {
                if i == 3 && (j == 0 || j == 6) {
                    offset += 1
                    continue
                }
                let letter = alphabet[i * 7 + j - offset]
                let letterButton = UIButton(type: .system)
                letterButton.setTitle(letter, for: .normal)
                letterButton.frame = CGRect(x: buttonWidth * j, y: buttonHeight * i, width: buttonWidth, height: buttonHeight)
                letterButton.addTarget(self, action: #selector(letterButtonTapped), for: .touchUpInside)
                alphabetButtons.append(letterButton)
                buttonsView.addSubview(letterButton)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let url = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let content = try? String(contentsOf: url) {
                words = content.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n")
            }
        }
        
        score = 0
        loadLevel()
    }

    func loadLevel() {
        level += 1
        livesLeft = 7
        currentWord = (words.randomElement() ?? "HELLO").map { char in
            String(char)
        }
        for button in alphabetButtons {
            button.isHidden = false
        }
    }
    
    @objc func letterButtonTapped(button: UIButton) {
        guard let letter = button.currentTitle else { return }
        
        button.isHidden = true
        
        if currentWord.contains(letter) {
            var indecies = [Int]()
            for (index, char) in currentWord.enumerated() {
                if letter == String(char) {
                    indecies.append(index)
                }
            }
            
            for index in indecies {
                guessedLetters[index] = letter
            }
            
            if !guessedLetters.contains("_") {
                winLevel()
            }
        } else {
            livesLeft -= 1
            if livesLeft == 0 {
                loseLevel()
            }
        }
    }
    
    func winLevel() {
        let ac = UIAlertController(title: "Good Job!", message: "You guessed the word correctly!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default) { [weak self] _ in
            self?.score += 1
            self?.loadLevel()
        })
        present(ac, animated: true)
    }
    
    func loseLevel() {
        let ac = UIAlertController(title: "No Lives Left!", message: "The correct word was \(currentWord.joined())", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default) { [weak self] _ in
            self?.score -= 1
            self?.loadLevel()
        })
        present(ac, animated: true)
    }
}
