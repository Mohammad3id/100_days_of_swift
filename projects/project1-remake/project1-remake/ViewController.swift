//
//  ViewController.swift
//  project1-remake
//
//  Created by Mohammad Eid on 20/01/2024.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileManager = FileManager()
        let path = Bundle.main.resourcePath!
        let contents = try! fileManager.contentsOfDirectory(atPath: path)
        
        for content in contents {
            if content.hasPrefix("nssl") {
                pictures.append(content)
            }
        }
        
        print(pictures)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture")!
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }


}

