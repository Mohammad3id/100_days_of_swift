//
//  GameScene.swift
//  milestone-project6
//
//  Created by Mohammad Eid on 15/02/2024.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var width: CGFloat { frame.width }
    var height: CGFloat { frame.height }
    
    var scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var timeLeftLabel = SKLabelNode(fontNamed: "Chalkduster")
    var timeLeft = 0 {
        didSet {
            timeLeftLabel.text = "Time: \(timeLeft)"
        }
    }
    var timer: Timer!
    var maxTime = 60
    
    
    var duckRows = [DuckRow]()
    
    var isGameOver = false
    
    var nextSpawnStamp: TimeInterval = 0
    var currentSpawnInterval: TimeInterval = 0.25
    
    var bulletRow: BulletRow!
    var reloadLabel = SKLabelNode(fontNamed: "Chalkduster")
    var shootingSound = SKAction.playSoundFileNamed("shot.wav", waitForCompletion: false)
    var reloadingSound = SKAction.playSoundFileNamed("reload.wav", waitForCompletion: false)
    
    override func didMove(to view: SKView) {
        // Background Setup
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: width / 2, y: height / 2)
        background.zPosition = -10
        background.size = CGSize(width: width, height: height)
        addChild(background)
        
        // Score Setup
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.verticalAlignmentMode = .top
        scoreLabel.position = CGPoint(x: 25, y: height - 25)
        addChild(scoreLabel)
        
        // Time Left Setup
        timeLeftLabel.horizontalAlignmentMode = .right
        timeLeftLabel.verticalAlignmentMode = .top
        timeLeftLabel.position = CGPoint(x: width - 25, y: height - 25)
        addChild(timeLeftLabel)
        
        // Rows Setup
        var duckRow = DuckRow()
        duckRow.configure(as: .leftToRight, minWidth: width)
        duckRow.position = CGPoint(x: width / 2, y: 300)
        duckRow.zPosition = 0
        duckRows.append(duckRow)
        addChild(duckRow)
        
        duckRow = DuckRow()
        duckRow.configure(as: .rightToLeft, minWidth: width)
        duckRow.position = CGPoint(x: width / 2, y: 150)
        duckRow.zPosition = 1
        duckRows.append(duckRow)
        addChild(duckRow)
        
        duckRow = DuckRow()
        duckRow.configure(as: .leftToRight, minWidth: width)
        duckRow.position = CGPoint(x: width / 2, y: 0)
        duckRow.zPosition = 2
        duckRows.append(duckRow)
        addChild(duckRow)
        
        bulletRow = BulletRow()
        bulletRow.configure(withCount: 6)
        bulletRow.position = CGPoint(x: width / 2, y: height - 50)
        addChild(bulletRow)
        
        reloadLabel.position = CGPoint(x: width / 2, y: height - 125)
        reloadLabel.text = "Reload"
        reloadLabel.isHidden = true
        addChild(reloadLabel)
        
        startGame()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isGameOver else { return }
        guard let location = touches.first?.location(in: self) else { return }
        
        let tappedNodes = nodes(at: location)
        
        if tappedNodes.contains(reloadLabel) {
            reloadLabel.isHidden = true
            bulletRow.reload()
            run(reloadingSound)
            return
        }
        
        if bulletRow.currentFill == 0 {
            return
        }

        bulletRow.shoot()
        run(shootingSound)
        reloadLabel.isHidden = false
        
        let ducks = tappedNodes.filter { $0.name?.starts(with: "duck") ?? false }
        
        for duck in ducks {
            if let duckTarget = duck.parent as? DuckTarget {
                duckTarget.die()
                
                if duckTarget.type == .bad {
                    score += 1
                } else {
                    score -= 5
                }
            }
        }//
//        if bulletRow.currentFill == 0 {
//            bulletRow.reload()
//        } else {
//            bulletRow.shoot()
//        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard !isGameOver else { return }
        
        if currentTime >= nextSpawnStamp {
            spawnRandomDuck()
            nextSpawnStamp = currentTime + currentSpawnInterval
            currentSpawnInterval = max(
                (TimeInterval(timeLeft) / TimeInterval(maxTime)) * 2,
                0.4
            )
        }
    }
    
    func spawnRandomDuck() {
        let randomDuckRow = duckRows.randomElement()!
        let randomDuckType: DuckType = Int.random(in: 1...100) > 80 ? .good : .bad
        let randomDuckScale = CGFloat.random(in: 0.5...1.5)
        let randomDuckSpeed = Double.random(in: 0...3)
        randomDuckRow.spawnDuck(of: randomDuckType, withScale: randomDuckScale, withSpeed: randomDuckSpeed)
    }
    
    func startGame() {
        bulletRow.reload()
        isGameOver = false
        score = 0
        timeLeft = maxTime
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.timeLeft -= 1
            if self?.timeLeft == 0 {
                self?.endGame()
            }
        }
    }
    
    func endGame() {
        timer.invalidate()
        
        isGameOver = true

        let gameOver = SKSpriteNode(imageNamed: "game-over")
        gameOver.position = CGPoint(x: width / 2, y: height / 2)
        gameOver.zPosition = 10
        addChild(gameOver)
    }
}
