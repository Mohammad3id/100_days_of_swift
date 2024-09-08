//
//  ViewController.swift
//  milestone-project10
//
//  Created by Mohammad Eid on 09/03/2024.
//

import UIKit
import WebKit

class ViewController: UICollectionViewController {
    var allCardContent = ["Cairo", "Beirut", "London", "Paris", "Berlin", "Rome", "Washington", "Bejin", "Athens", "Dublin"]

    var cardContent = [String]()
    var cards = [CardCell]()
    var flippedCards = [CardCell]()
    var pairsCount = 10
    var matchedPairsCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startGame()
    }
    
    func startGame() {
        allCardContent.shuffle()
        let randomContent = Array(allCardContent[..<pairsCount])
        cardContent = randomContent + randomContent
        cardContent.shuffle()
        matchedPairsCount = 0
        flippedCards.removeAll()
        for (index, card) in cards.enumerated() {
            card.layer.opacity = 1
            card.initialize(with: cardContent[index])
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardContent.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let card = collectionView.dequeueReusableCell(withReuseIdentifier: "Card", for: indexPath) as! CardCell
        card.initialize(with: cardContent[indexPath.item])
        cards.append(card)
        return card
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let card = cards[indexPath.item]
        
        if card.state == .matched { return }
        
        if card.state == .facingUp {
            card.flipDown()
            flippedCards.removeAll()
        } else {
            card.flipUp()
            flippedCards.append(card)
        }
        
        if flippedCards.count == 2 {
            let card1 = flippedCards[0]
            let card2 = flippedCards[1]
            
            flippedCards.removeAll()
            
            if card1.contentLabel.text == card2.contentLabel.text {
                card1.state = .matched
                card2.state = .matched
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    UIView.animate(withDuration: 0.5) {
                        card1.layer.opacity = 0
                        card2.layer.opacity = 0
                    }
                }
                matchedPairsCount += 1
                
                if (matchedPairsCount == pairsCount) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.endGame()
                    }
                }
                
                
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    card1.flipDown()
                    card2.flipDown()
                }

            }
        }
    }
    
    func endGame() {
        let ac = UIAlertController(title: "Game Over", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Play Again", style: .default) { [weak self] _ in
            self?.startGame()
        })
        present(ac, animated: true)
    }
}
