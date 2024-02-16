//
//  Bullet.swift
//  milestone-project6
//
//  Created by Mohammad Eid on 16/02/2024.
//

import SpriteKit

class Bullet: SKNode {
    private var emptyBullet: SKSpriteNode!
    private var filledBullet: SKSpriteNode!
    
    var state: BulletState! {
        didSet {
            guard oldValue != state else { return }
            
            if state == .empty {
                filledBullet.removeFromParent()
                addChild(emptyBullet)
            } else {
                emptyBullet.removeFromParent()
                addChild(filledBullet)
            }
        }
    }
    
    func configure(as state: BulletState) {
        emptyBullet = SKSpriteNode(imageNamed: "empty-bullet")
        filledBullet = SKSpriteNode(imageNamed: "filled-bullet")
        
        self.state = state
    }
    
    func toggle() {
        if state == .empty {
            state = .filled
        } else {
            state = .empty
        }
    }
}
