//
//  BulletRow.swift
//  milestone-project6
//
//  Created by Mohammad Eid on 16/02/2024.
//

import SpriteKit

class BulletRow: SKNode {
    private var bullets = [Bullet]()
    private var _currentFill = 0
    var currentFill: Int { _currentFill }
    
    func configure(withCount count: Int) {
        assert(count != 0, "Must have at least one bullet!")
        
        let space: CGFloat = 30
        let offset: CGFloat = (space / 2) * CGFloat(count - 1)

        for i in 0..<count {
            let bullet = Bullet()
            bullet.configure(as: .filled)
            bullet.position = CGPoint(x: CGFloat(i) * space - offset, y: 0)
            addChild(bullet)
            bullets.append(bullet)
        }
        
        _currentFill = count
    }
    
    func shoot() {
        guard currentFill != 0 else { return }
        bullets[currentFill - 1].state = .empty
        _currentFill -= 1
    }
    
    func reload() {
        for bullet in bullets {
            bullet.state = .filled
        }
        _currentFill = bullets.count
    }
}
