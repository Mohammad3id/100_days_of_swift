//
//  DetailViewController.swift
//  milestone-project4
//
//  Created by Mohammad Eid on 05/02/2024.
//

import UIKit

class DetailViewController: UIViewController {

    var image: AppImage!
    
    
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = image.caption
        let imageURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(image.image)
        imageView.image = UIImage(contentsOfFile: imageURL.path())
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
