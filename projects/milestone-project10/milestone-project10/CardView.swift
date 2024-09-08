//
//  CardView.swift
//  milestone-project10
//
//  Created by Mohammad Eid on 09/03/2024.
//

import UIKit

enum CardState {
    case facingDown
    case facingUp
    case matched
}

class CardCell: UICollectionViewCell {
    var state: CardState = .facingDown
    
    var content: String!
    
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var frontFace: UIView!
    @IBOutlet var backFace: UIView!
    
    
    func initialize(with content: String) {
        contentLabel.text = content
        frontFace.layer.opacity = 0.01
        state = .facingDown
    }
    
    func flipUp() {
        if (state != .facingDown) { return }
            
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight]
        
        
        UIView.transition(with: backFace, duration: 1.0, options: transitionOptions) {}
        
        
        UIView.transition(with: frontFace, duration: 0) {
            self.frontFace.layer.opacity = 1
        }
        
        UIView.transition(with: frontFace, duration: 1.0, options: transitionOptions) {}
        
        state = .facingUp
    }
    
    func flipDown() {
        if (state != .facingUp) { return }
            
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight]
        
        
        UIView.transition(with: backFace, duration: 1.0, options: transitionOptions) {}
        
        UIView.transition(with: frontFace, duration: 0) {
            self.frontFace.layer.opacity = 0.01
        }
        
        UIView.transition(with: frontFace, duration: 1.0, options: transitionOptions) {}
        
        state = .facingDown
    }
    
    func reset() {
        self.frontFace.layer.opacity = 0.01
        state = .facingDown
    }

}
