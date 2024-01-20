//
//  DetailViewController.swift
//  project1-remake
//
//  Created by Mohammad Eid on 20/01/2024.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet var imageView: UIImageView!
    var selectedPicture: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let selectedPicture {
            imageView.image = UIImage(named: selectedPicture)
        }
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.hidesBarsOnTap = false
    }


}
