//
//  DetailViewController.swift
//  milestone-project5
//
//  Created by Mohammad Eid on 11/02/2024.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var CapitalLabel: UILabel!
    @IBOutlet var AreaLabel: UILabel!
    @IBOutlet var PopulationLabel: UILabel!
    @IBOutlet var FlagImageView: UIImageView!
    
    var country: Country?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let country {
            title = country.name
            CapitalLabel.text = country.capital.capitalized
            AreaLabel.text = "\(country.area) km²"
            PopulationLabel.text = "\(country.population) people"
            FlagImageView.image = UIImage(named: country.flag)
        }
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
