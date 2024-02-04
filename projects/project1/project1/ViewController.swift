//
//  ViewController.swift
//  project1
//
//  Created by Mohammad Eid on 18/01/2024.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    
    var pictureViews = [String: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DispatchQueue.global().async {
            self.loadPictures()
        }
        
        title = "Storm Viewer"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
    }
    
    func loadPictures() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        pictures.sort()
        
        let defaults = UserDefaults.standard
        
        for picture in pictures {
            pictureViews[picture] = defaults.integer(forKey: "\(picture)_views")
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        let picture = pictures[indexPath.row]
        cell.textLabel?.text = picture
        cell.detailTextLabel?.text = "\(pictureViews[picture] ?? 0)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailViewController = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            let picture = pictures[indexPath.row]
            detailViewController.selectedImage = picture
            detailViewController.title = "Picture \(indexPath.row + 1) of \(pictures.count)"
            navigationController?.pushViewController(detailViewController, animated: true)
            
            let newViews = pictureViews[picture, default: 0] + 1
            pictureViews[picture] = newViews
            UserDefaults.standard.setValue(newViews, forKey: "\(picture)_views")
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }

}

