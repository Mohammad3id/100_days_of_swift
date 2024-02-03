//
//  GameScene.swift
//  project11
//
//  Created by Mohammad Eid on 03/02/2024.
//

import GameplayKit
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var ballsLeftLabel = SKLabelNode(fontNamed: "Chalkduster")
    var ballsLeft = 5 {
        didSet {
            ballsLeftLabel.text = "Balls: \(ballsLeft)"
        }
    }

    var editLabel = SKLabelNode(fontNamed: "Chalkduster")
    var editingMode = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    let ballYThreshold = CGFloat(500)

    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self

        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)

        makeSlot(at: CGPoint(x: 128, y: -10), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: -10), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: -10), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: -10), isGood: false)

        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))

        score = 0
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 10, y: 670)
        addChild(scoreLabel)

        editingMode = false
        editLabel.position = CGPoint(x: 512, y: 670)
        addChild(editLabel)
        
        ballsLeft = 5
        ballsLeftLabel.position = CGPoint(x: 950, y: 670)
        addChild(ballsLeftLabel)
        
        let ballThresholdLine = SKShapeNode(rect: CGRect(x: -100, y: ballYThreshold, width: 2000, height: 1))
        ballThresholdLine.fillColor = UIColor.red
        addChild(ballThresholdLine)
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)

            let objects = nodes(at: location)

            if objects.contains(editLabel) {
                editingMode.toggle()
                ballsLeft = 5
                score = 0
            } else {
                if editingMode {
                    if location.y < ballYThreshold {
                        makeObstacle(at: location)
                    }
                } else {
                    if location.y > ballYThreshold && ballsLeft > 0 {
                        makeBall(at: location)
                    }
                }
            }
        }
    }

    func makeBall(at position: CGPoint) {
        let ballImageNames = ["ballBlue", "ballYellow", "ballPurple", "ballGrey", "ballRed", "ballCyan", "ballGreen" ]
        let ball = SKSpriteNode(imageNamed: ballImageNames.randomElement()!)
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        ball.physicsBody?.contactTestBitMask = ball.physicsBody!.collisionBitMask
        ball.physicsBody?.restitution = 0.4
        ball.position = position
        ball.name = "ball"
        addChild(ball)
        
        ballsLeft -= 1
    }

    func makeObstacle(at position: CGPoint) {
        let size = CGSize(width: Int.random(in: 16 ... 128), height: 16)
        let box = SKSpriteNode(
            color: UIColor(
                red: CGFloat.random(in: 0 ... 1),
                green: CGFloat.random(in: 0 ... 1),
                blue: CGFloat.random(in: 0 ... 1),
                alpha: 1
            ),
            size: size
        )
        box.zRotation = CGFloat.random(in: 0 ... 3)
        box.position = position
        
        box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
        box.physicsBody?.isDynamic = false
        
        box.name = "obstacle"
        
        addChild(box)
        
    }

    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }

    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode

        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }

        slotBase.position = position
        slotGlow.position = position
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false

        addChild(slotBase)
        addChild(slotGlow)

        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }

    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        

        if nodeA.name == "ball" {
            colltionBetween(ball: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            colltionBetween(ball: nodeB, object: nodeA)
        }
        
        if nodeA.name == "obstacle" {
            nodeA.removeFromParent()
        } else if nodeB.name == "obstacle" {
            nodeB.removeFromParent()
        }
    }

    func colltionBetween(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball)
            score += 1
            ballsLeft += 1
        } else if object.name == "bad" {
            destroy(ball)
            score -= 1
        }
    }

    func destroy(_ ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        ball.removeFromParent()
    }
}
