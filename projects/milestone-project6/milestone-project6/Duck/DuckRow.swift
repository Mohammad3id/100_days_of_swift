//
//  DuckRow.swift
//  milestone-project6
//
//  Created by Mohammad Eid on 15/02/2024.
//

import SpriteKit

class DuckRow: SKNode {
    private var spawnDirection: DuckDirection!
    private var waterForeground: SKSpriteNode!
    
    func configure(as direction: DuckDirection, minWidth: CGFloat) {
        spawnDirection = direction
        waterForeground = SKSpriteNode(imageNamed: "water")
        waterForeground.xScale = max(1, minWidth / waterForeground.size.width)
        waterForeground.zPosition = zPosition
        addChild(waterForeground)
    }
    
    func spawnDuck(of type: DuckType, withScale scale: CGFloat = 1, withSpeed speed: Double = 1) {
        let duck = DuckTarget()
        duck.configure(as: type, withScale: scale)
        
        duck.zPosition = waterForeground.zPosition - 0.1

        let spawnY = waterForeground.size.height * 0.8
        let spawnX = -waterForeground.size.width / 2 - 200
        
        let movementAction: SKAction
        if spawnDirection == .rightToLeft {
            duck.xScale = -1
            duck.position = CGPoint(
                x: -spawnX,
                y: spawnY
            )
            movementAction = SKAction.moveTo(x: spawnX, duration: max(5 - speed, 1))
        } else {
            duck.position = CGPoint(
                x: spawnX,
                y: spawnY
            )
            movementAction = SKAction.moveTo(x: -spawnX, duration: max(5 - speed, 1))
        }

        addChild(duck)
        
        let moveUpAction = SKAction.move(by: CGVector(dx: 0, dy: 50), duration: 0.5)
        moveUpAction.timingMode = .easeInEaseOut
        
        let moveDownAction = SKAction.move(by: CGVector(dx: 0, dy: -50), duration: 0.5)
        moveDownAction.timingMode = .easeInEaseOut
        
        let oscilationAction = SKAction.repeatForever(
            SKAction.sequence([moveDownAction, moveUpAction])
        )
        
        duck.run(oscilationAction)
        duck.run(movementAction) {
            duck.removeFromParent()
        }
    }
}
