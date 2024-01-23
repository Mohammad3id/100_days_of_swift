//
//  ViewController.swift
//  project2
//
//  Created by Mohammad Eid on 21/01/2024.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!

    var countries = [String]()
    var correctAnswer = 0

    var round = 0
    var score = 0

    var maxRounds = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]

        button1.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        button2.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        button3.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showScore))

        askQuestion()
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        var message: String?
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong"
            message = "That's the flag of \(countries[sender.tag].uppercased())."
        }

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Continue", style: .default) { [self] _ in
            if round == maxRounds {
                endGame()
            } else {
                askQuestion()
            }
        })
        present(alertController, animated: true)
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0 ... 2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)

        round += 1
        title = "\(countries[correctAnswer].uppercased()) (Round: \(round))"
    }

    func endGame() {
        let alertController = UIAlertController(title: "Game Over", message: "You scored \(score) out of \(maxRounds)", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Play Again", style: .default) { _ in
            self.score = 0
            self.round = 0
            self.askQuestion()
        })
        present(alertController, animated: true)
    }
    
    @objc func showScore() {
        let activityViewController = UIActivityViewController(activityItems: ["Score: \(score)"], applicationActivities: [])
        activityViewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        activityViewController.
        present(activityViewController, animated: true)
    }
}
