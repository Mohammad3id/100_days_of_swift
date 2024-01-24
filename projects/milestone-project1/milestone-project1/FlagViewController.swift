//
//  FlagViewController.swift
//  milestone-project1
//
//  Created by Mohammad Eid on 24/01/2024.
//

import UIKit

class FlagViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var selectedFlag: String?
    var selectedFlagName: String? {
        if let selectedFlag {
            selectedFlag[..<selectedFlag.index(selectedFlag.endIndex, offsetBy: -7)].uppercased()
        } else {
            nil
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        if let selectedFlag {
            imageView.image = UIImage(named: selectedFlag)
            title = selectedFlagName
        }

        navigationItem.largeTitleDisplayMode = .never

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnTap = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.hidesBarsOnTap = false
    }

    @objc func shareTapped() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8), let selectedFlagName else {
            return
        }
        
        let vc = UIActivityViewController(activityItems: [image, selectedFlagName], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
        
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}
