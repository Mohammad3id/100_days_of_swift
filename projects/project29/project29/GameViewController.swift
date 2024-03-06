//
//  GameViewController.swift
//  project29
//
//  Created by Mohammad Eid on 03/03/2024.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var currentGame: GameScene!
    
    @IBOutlet var angleSlider: UISlider!
    @IBOutlet var angleLabel: UILabel!
    
    
    @IBOutlet var velocitySlider: UISlider!
    @IBOutlet var velocityLabel: UILabel!
    
    @IBOutlet var launchButton: UIButton!
    @IBOutlet var playerNumber: UILabel!
    
    @IBOutlet var player1ScoreLabel: UILabel!
    @IBOutlet var player2ScoreLabel: UILabel!
    
    @IBOutlet var windLabel: UILabel!
    
    var player1Score = 0 {
        didSet {
            player1ScoreLabel.text = "PLAYER ONE: \(player1Score)"
        }
    }
    var player2Score = 0 {
        didSet {
            player2ScoreLabel.text = "PLAYER TWO: \(player2Score)"
        }
    }
    @IBOutlet var endLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        angleChanged(angleSlider)
        velocityChanged(velocitySlider)
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                currentGame = scene as? GameScene
                currentGame.viewController = self
                resetGame(with: 1)

                view.presentScene(scene)                
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func angleChanged(_ sender: UISlider) {
        angleLabel.text = "Angle: \(Int(angleSlider.value))°"
    }
    
    @IBAction func velocityChanged(_ sender: UISlider) {
        velocityLabel.text = "Velocity: \(Int(velocitySlider.value))"
    }
    
    func resetGame(with player: Int) {
        endLabel.isHidden = true
        player1Score = 0
        player2Score = 0
    }
    
    @IBAction func launch(_ sender: UIButton) {
        angleSlider.isHidden = true
        angleLabel.isHidden = true

        velocitySlider.isHidden = true
        velocityLabel.isHidden = true

        launchButton.isHidden = true

        currentGame.launch(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
    }
    
    func activatePlayer(number: Int) {
        if number == 1 {
            playerNumber.text = "<<< PLAYER ONE"
        } else {
            playerNumber.text = "PLAYER TWO >>>"
        }

        angleSlider.isHidden = false
        angleLabel.isHidden = false

        velocitySlider.isHidden = false
        velocityLabel.isHidden = false

        launchButton.isHidden = false
    }
    
    func addPoint(to player: Int) {
        if (player == 1) {
            player1Score += 1
        } else {
            player2Score += 1
        }
        
        if (player1Score == 3 || player2Score == 3) {
            endGame()
        }
    }
    
    func endGame() {
        endLabel.text = ""
        
        if (player1Score == 3) {
            endLabel.text = "PLAYER ONE WINS"
        } else if (player2Score == 3) {
            endLabel.text = "PLAYER TWO WINS"
        }
        
        endLabel.isHidden = false
    }
}
