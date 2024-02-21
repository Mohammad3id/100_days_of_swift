//
//  Title.swift
//  milestone-project7
//
//  Created by Mohammad Eid on 21/02/2024.
//

import UIKit

class TitleTextView: UITextView, UITextViewDelegate {

    override func didAddSubview(_ subview: UIView) {
        textContainer.maximumNumberOfLines = 1
        delegate = self
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        
        guard !text.contains("\n") else { return false }
        guard let stringRange = Range(range, in: currentText) else { return false}
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        return updatedText.count <= 30
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
