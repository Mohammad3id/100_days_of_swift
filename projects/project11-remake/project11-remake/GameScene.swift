//
//  GameScene.swift
//  project11-remake
//
//  Created by Mohammad Eid on 05/02/2024.
//

import GameplayKit
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var width: CGFloat!
    var height: CGFloat!

    let bouncerSize = CGSize(width: 150, height: 150)
    let bouncerCount = 5

    var slotWidth: CGFloat {
        let leftSpace = width - bouncerSize.width * CGFloat(bouncerCount - 1)
        return leftSpace / CGFloat(bouncerCount - 1)
    }
    
    let ballSize = CGSize(width: 50, height: 50)
    let ballAssets = ["ballBlue", "ballYellow", "ballPurple", "ballGrey", "ballRed", "ballCyan", "ballGreen"]
    
    var scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var ballsLeftLabel = SKLabelNode(fontNamed: "Chalkduster")
    var ballsLeft = 0 {
        didSet {
            ballsLeftLabel.text = "Balls: \(ballsLeft)"
        }
    }
    
    var resetLabel = SKLabelNode(fontNamed: "Chalkduster")
    
    var threshold: CGFloat {
        height * 0.7
    }
    
    let obstaclesCount = 100
    var curretnObstacles = [SKNode]()
    
    

    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        height = frame.size.height
        width = frame.size.width

        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: width / 2, y: height / 2)
        background.zPosition = -1
        background.setScale(max(width / background.size.width, height / background.size.height))
        addChild(background)

        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 50, y: height - 50)
        addChild(scoreLabel)

        resetLabel.text = "Reset"
        resetLabel.position = CGPoint(x: width / 2, y: height - 50)
        addChild(resetLabel)
        
        ballsLeftLabel.horizontalAlignmentMode = .right
        ballsLeftLabel.position = CGPoint(x: width - 50, y: height - 50)
        addChild(ballsLeftLabel)
        
        let thresholdLine = SKShapeNode(rectOf: CGSize(width: width * 1.1, height: 1))
        thresholdLine.position = CGPoint(x: width / 2, y: threshold)
        addChild(thresholdLine)
        
        makeSlots()
        makeBouncers()
        
        startGame()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            if nodes(at: location).contains(resetLabel) {
                startGame()
                return
            }
            
            if location.y > threshold && ballsLeft > 0{
                ballsLeft -= 1
                makeBall(at: location)
            }
        }
    }
    
    func startGame() {
        for obstacle in curretnObstacles {
            obstacle.removeFromParent()
        }
        
        score = 0
        ballsLeft = 5
        
        for _ in 0...obstaclesCount {
            let position = CGPoint(
                x: CGFloat.random(in: 0...width),
                y: CGFloat.random(in: bouncerSize.height...(threshold - 100))
            )
            
            let size = CGSize(width: CGFloat.random(in: 50...200), height: 10)
            
            let obstacle = SKSpriteNode(
                color: UIColor(
                    red: CGFloat.random(in: 0 ... 1),
                    green: CGFloat.random(in: 0 ... 1),
                    blue: CGFloat.random(in: 0 ... 1),
                    alpha: 1
                ),
                size: size
            )
            
            obstacle.position = position
            obstacle.zRotation = CGFloat.random(in: 0...3)
            obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
            obstacle.physicsBody?.isDynamic = false
            
            obstacle.name = "obstacle"

            curretnObstacles.append(obstacle)
            
            addChild(obstacle)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let node1 = contact.bodyA.node else { return }
        guard let node2 = contact.bodyB.node else { return }
        
        if node1.name == "ball" && (node2.name == "goodSlot" || node2.name == "badSlot") {
            handleBallSlotContact(ball: node1, slot: node2)
        } else if node2.name == "ball" && (node1.name == "goodSlot" || node1.name == "badSlot") {
            handleBallSlotContact(ball: node2, slot: node1)
        }
        
        if node1.name == "ball" && node2.name == "obstacle" {
            node2.removeFromParent()
        } else if node2.name == "ball" && node1.name == "obstacle" {
            node1.removeFromParent()
        }
    }
    
    func handleBallSlotContact(ball: SKNode, slot: SKNode) {
        let isGood = slot.name == "goodSlot"
        
        if let fireParticle = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticle.position = ball.position
            addChild(fireParticle)
        }
        
        ball.removeFromParent()
        
        if isGood {
            score += 1
            ballsLeft += 1
        } else {
            score -= 1
        }
    }
    
    
    func makeBall(at position: CGPoint) {
        let ball = SKSpriteNode(imageNamed: ballAssets.randomElement()!)
        ball.position = position
        ball.size = ballSize
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ballSize.width / 2)
        ball.physicsBody?.restitution = 0.4
        ball.name = "ball"
        ball.physicsBody?.contactTestBitMask = ball.physicsBody!.collisionBitMask
        addChild(ball)
    }

    func makeBouncers() {
        var position = CGPoint(x: 0, y: 0)

        for _ in 0 ..< bouncerCount {
            let bouncer = SKSpriteNode(imageNamed: "bouncer")
            bouncer.position = position
            bouncer.size = bouncerSize
            bouncer.zPosition = 1
            
            bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncerSize.width / 2)
            bouncer.physicsBody?.isDynamic = false
            bouncer.physicsBody?.restitution = 0.8
            
            addChild(bouncer)
            position.x += bouncerSize.width + slotWidth
        }
    }

    func makeSlots() {
        var position = CGPoint(x: bouncerSize.width / 2 + slotWidth / 2, y: -10)

        for i in 0 ..< bouncerCount - 1 {
            let isGood = i % 2 == 0

            // Slot base
            let slot = SKShapeNode(rectOf: CGSize(width: slotWidth, height: 10))
            slot.position = position
            slot.fillColor = isGood ? UIColor.green : UIColor.red
            slot.strokeColor = slot.fillColor
            slot.name = isGood ? "goodSlot" : "badSlot"
            slot.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: slotWidth, height: 10))
            slot.physicsBody?.isDynamic = false
            addChild(slot)

            // Slot glow
            let slotGlow = SKSpriteNode(imageNamed: isGood ? "slotGlowGood" : "slotGlowBad")
            slotGlow.setScale((slotWidth * 1.75) / slotGlow.size.width)
            slotGlow.position = position

            addChild(slotGlow)

            let rotationAction = SKAction.rotate(byAngle: CGFloat.pi, duration: 10)
            let rotationRepeat = SKAction.repeatForever(rotationAction)
            slotGlow.run(rotationRepeat)

            position.x += bouncerSize.width + slotWidth
        }
    }
}
