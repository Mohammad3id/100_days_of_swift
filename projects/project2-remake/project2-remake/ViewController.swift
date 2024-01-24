//
//  ViewController.swift
//  project2-remake
//
//  Created by Mohammad Eid on 24/01/2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
    var correctAnswer = 0
    var maxRounds = 10
    var currentRound = 0
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        button1.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        button2.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        button3.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        
        askQuestion()
    }
    
    func askQuestion() {
        currentRound += 1
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        title = "\(countries[correctAnswer].uppercased()) (Round: \(currentRound))"
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
    }
    
    func endGame() {
        let alert = UIAlertController(title: "Game Over", message: "You scored \(score) out of \(maxRounds)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Play Again", style: .default) { [self] _ in
            currentRound = 0
            score = 0
            askQuestion()
        })
        present(alert, animated: true)
    }

    @IBAction func onTap(_ sender: UIButton) {
        var title: String
        var message: String?
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong"
            message = "That's the flag of \(countries[sender.tag].uppercased())"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Continue", style: .default) { [self] _ in
            if currentRound == maxRounds {
                endGame()
            } else {
                askQuestion()
            }
        })
        
        present(alert, animated: true)
    }
}

