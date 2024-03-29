//
//  ViewController.swift
//  project15
//
//  Created by Mohammad Eid on 09/02/2024.
//

import UIKit

class ViewController: UIViewController {
    var imageView: UIImageView!
    var currentAnimation = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView = UIImageView(image: UIImage(named: "penguin"))

        let width = view.frame.size.width
        let height = view.frame.size.height

        imageView.center = CGPoint(x: width / 2, y: height / 2)

        view.addSubview(imageView)
    }

    @IBAction func tapped(_ sender: UIButton) {
        sender.isHidden = true

        UIView.animate(
            withDuration: 1,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 5,
            options: [],
            animations: {
                switch self.currentAnimation {
                case 0:
                    self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
                case 1:
                    self.imageView.transform = CGAffineTransform.identity
                case 2:
                    self.imageView.transform = CGAffineTransform(translationX: -256, y: -256)
                case 3:
                    self.imageView.transform = CGAffineTransform.identity
                case 4:
                    self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                case 5:
                    self.imageView.transform = CGAffineTransform.identity
                case 6:
                    self.imageView.alpha = 0.1
                    self.imageView.backgroundColor = UIColor.green
                case 7:
                    self.imageView.alpha = 1
                    self.imageView.backgroundColor = UIColor.clear
                default:
                    break
                }
            },
            completion: { _ in
                sender.isHidden = false
            }
        )

        currentAnimation = (currentAnimation + 1) % 8
    }
}
