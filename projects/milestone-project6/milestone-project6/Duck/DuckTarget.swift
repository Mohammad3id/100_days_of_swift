//
//  DuckTarget.swift
//  milestone-project6
//
//  Created by Mohammad Eid on 15/02/2024.
//

import SpriteKit

class DuckTarget: SKNode {
    
    private var _type: DuckType!
    var type: DuckType { _type }
    
    private var duck: SKSpriteNode!
    private var stick: SKSpriteNode!
    
    func configure(as type: DuckType, withScale scale: CGFloat = 1) {
        assert(_type == nil, "DuckTarget already configured")
        assert(duck == nil, "DuckTarget already configured")
        
        _type = type
        
        switch type {
        case .good:
            duck = SKSpriteNode(imageNamed: "duck-good")
            duck.name = "duck-good"
        case .bad:
            duck = SKSpriteNode(imageNamed: "duck-bad")
            duck.name = "duck-bad"
        }
        
        duck.zPosition = zPosition
        duck.setScale(scale)
        stick = SKSpriteNode(imageNamed: "stick")
        stick.zPosition = duck.zPosition - 0.1
        stick.position.y -= 75
        
        addChild(stick)
        addChild(duck)
    }
    
    func die() {
        run(SKAction.move(by: CGVector(dx: 0, dy: -100), duration: 0.2))
        run(SKAction.rotate(byAngle: CGFloat.pi / 2 * [1, -1].randomElement()!, duration: 0.2))
        run(SKAction.fadeOut(withDuration: 0.2)) { [weak self] in
            self?.removeAllActions()
            self?.removeFromParent()
        }
    }
    
    
}
