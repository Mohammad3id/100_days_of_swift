//
//  ViewController.swift
//  milestone-project1
//
//  Created by Mohammad Eid on 24/01/2024.
//

import UIKit

class ViewController: UITableViewController {

    var flags = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let fm = FileManager()
        let path = Bundle.main.resourcePath!
        let contents = try! fm.contentsOfDirectory(atPath: path)
        
        for content in contents {
            if content.hasSuffix(".png") {
                flags.append(content)
            }
        }
        
        title = "Flags"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        flags.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlagCell", for: indexPath)
        
        let flag = flags[indexPath.row]
        let flagName = flag[..<flag.index(flag.endIndex, offsetBy: -7)].uppercased()
        
        cell.imageView?.image = UIImage(named: flag)
        cell.textLabel?.text = flagName
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "FlagView") as? FlagViewController {
            vc.selectedFlag = flags[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

