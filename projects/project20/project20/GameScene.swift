//
//  GameScene.swift
//  project20
//
//  Created by Mohammad Eid on 19/02/2024.
//

import GameplayKit
import SpriteKit

class GameScene: SKScene {
    var gameTimer: Timer?
    var fireworks = [SKNode]()

    var width: CGFloat { frame.width }
    var height: CGFloat { frame.height }

    let leftEdge = -22
    let bottomEdge = -22
    var rightEdge: Int { Int(width) + 22 }

    var scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }

    var launchCounter = 0
    var gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: width / 2, y: height / 2)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)

        scoreLabel.position = CGPoint(x: width - 25, y: height - 25)
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.verticalAlignmentMode = .top
        addChild(scoreLabel)
        score = 0
        
        gameOverLabel.text = "Game Over!"
        gameOverLabel.fontSize = 70
        gameOverLabel.position = CGPoint(x: width / 2, y: height / 2)
        gameOverLabel.isHidden = true
        addChild(gameOverLabel)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        checkTouches(touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        checkTouches(touches)
    }

    override func update(_ currentTime: TimeInterval) {
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.y > height + 150 {
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
    }

    @objc func launchFireworks() {
        if launchCounter >= 20 {
            gameTimer?.invalidate()
            gameOverLabel.isHidden = false
            return
        }
        
        launchCounter += 1
        
        let movementAmount: CGFloat = 1800

        switch Int.random(in: 0 ... 3) {
        case 0:
            // fire five, straight up
            createFirework(xMovement: 0, x: Int(width / 2 - 200), y: bottomEdge)
            createFirework(xMovement: 0, x: Int(width / 2 - 100), y: bottomEdge)
            createFirework(xMovement: 0, x: Int(width / 2), y: bottomEdge)
            createFirework(xMovement: 0, x: Int(width / 2 + 100), y: bottomEdge)
            createFirework(xMovement: 0, x: Int(width / 2 + 200), y: bottomEdge)

        case 1:
            // fire five, in a fan
            createFirework(xMovement: -200, x: Int(width / 2 - 200), y: bottomEdge)
            createFirework(xMovement: -100, x: Int(width / 2 - 100), y: bottomEdge)
            createFirework(xMovement: 0, x: Int(width / 2), y: bottomEdge)
            createFirework(xMovement: 100, x: Int(width / 2 + 100), y: bottomEdge)
            createFirework(xMovement: 200, x: Int(width / 2 + 200), y: bottomEdge)

        case 2:
            // fire five, from the left to the right
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge)

        case 3:
            // fire five, from the right to the left
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)

        default:
            break
        }
    }

    func createFirework(xMovement: CGFloat, x: Int, y: Int) {
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)

        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.colorBlendFactor = 1
        firework.name = "firework"
        node.addChild(firework)

        let colors: [UIColor] = [.cyan, .green, .red]
        firework.color = colors.randomElement()!

        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: xMovement, y: 1000))

        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        node.run(move)

        if let emmiter = SKEmitterNode(fileNamed: "fuse") {
            emmiter.position = CGPoint(x: 0, y: -22)
            node.addChild(emmiter)
        }

        fireworks.append(node)
        addChild(node)
    }

    func checkTouches(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }

        let location = touch.location(in: self)

        for case let node as SKSpriteNode in nodes(at: location) {
            guard node.name == "firework" else { return }

            for parent in fireworks {
                guard let firework = parent.children.first as? SKSpriteNode else { continue }

                if firework.name == "selected" && firework.color != node.color {
                    firework.name = "firework"
                    firework.colorBlendFactor = 1
                }
            }
            node.name = "selected"
            node.colorBlendFactor = 0
        }
    }

    func explodeFireworks() {
        var numExploded = 0

        for (index, fireworkContainer) in fireworks.enumerated().reversed() {
            guard let firework = fireworkContainer.children.first as? SKSpriteNode else { return }

            if firework.name == "selected" {
                explode(firework: fireworkContainer)
                fireworks.remove(at: index)
                numExploded += 1
            }
        }

        switch numExploded {
        case 0:
            // nothing – rubbish!
            break
        case 1:
            score += 200
        case 2:
            score += 500
        case 3:
            score += 1500
        case 4:
            score += 2500
        default:
            score += 4000
        }
    }

    func explode(firework: SKNode) {
        if let emmiter = SKEmitterNode(fileNamed: "explode") {
            emmiter.position = firework.position
            addChild(emmiter)
            run(SKAction.sequence([
                SKAction.wait(forDuration: 1),
                SKAction.run { emmiter.removeFromParent() }
            ]))
        }

        firework.removeFromParent()
    }
}
