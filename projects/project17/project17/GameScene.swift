//
//  GameScene.swift
//  project17
//
//  Created by Mohammad Eid on 13/02/2024.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var height: CGFloat { frame.height }
    var width: CGFloat { frame.width }
    
    var possibleEnemies = [SKSpriteNode]()
    
    var isGameOver = false
    
    var allowMovement = false
    
    var gameTimer: Timer?
    var interval: TimeInterval = 1
    var enemiesCount = 0
    
    
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        starfield = SKEmitterNode(fileNamed: "starfield")
        starfield.position = CGPoint(x: width, y: height / 2)
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -1
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: height / 2)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        score = 0
        addChild(scoreLabel)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        gameTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(createEnemey), userInfo: nil, repeats: true)
        
        for enemy in ["ball", "hammer", "tv"] {
            let sprite = SKSpriteNode(imageNamed: enemy)
            
            sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
            sprite.physicsBody?.categoryBitMask = 1
            sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
            sprite.physicsBody?.angularVelocity = 5
            sprite.physicsBody?.linearDamping = 0
            sprite.physicsBody?.angularDamping = 0
            
            
            possibleEnemies.append(sprite)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -500 {
                node.removeFromParent()
            }
        }
        
        if !isGameOver {
            score += 1
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        allowMovement = nodes(at: location).contains(player)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard allowMovement else { return }
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)
        
        if location.y < 100 {
            location.y = 100
        } else if location.y > height - 100 {
            location.y = height - 100
        }
        
        player.position = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        allowMovement = false
    }
    
    @objc func createEnemey() {
        guard let sprite = possibleEnemies.randomElement() else { return }

        let enemy = sprite.copy() as! SKSpriteNode
        
        enemy.position = CGPoint(
            x: Int(width + 200),
            y: Int.random(in: 50...Int(height - 50))
        )
        
        addChild(enemy)
        
        enemiesCount += 1
        
        if enemiesCount.isMultiple(of: 20) {
            interval *= 0.9
            gameTimer?.invalidate()
            gameTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(createEnemey), userInfo: nil, repeats: true)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)
        
        player.removeFromParent()

        isGameOver = true
        gameTimer?.invalidate()
    }
}
