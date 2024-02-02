//
//  ViewController.swift
//  project7-remake
//
//  Created by Mohammad Eid on 02/02/2024.
//

import UIKit

class ViewController: UITableViewController {
    var allPetitions = [Petition]()
    var displayedPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearch))
        
        title = "Petitions"
        
        let urlString = if navigationController?.tabBarItem.tag == 0 {
            "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        DispatchQueue.global().async {
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.parse(data)
                    }
                    return
                }
            }
        }
    }

    @objc func showSearch() {
        let ac = UIAlertController(title: "Search", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Done", style: .default) { [weak self, weak ac] _ in
            if let text = ac?.textFields?[0].text {
                self?.search(text)
            }
        })
        present(ac, animated: true)
    }
    
    func search(_ text: String) {
        if text.isEmpty {
            displayedPetitions = allPetitions
            tableView.reloadData()
            return
        }
        
        DispatchQueue.global().async {
            self.displayedPetitions = self.allPetitions.filter { petition in
                petition.title.lowercased().contains(text.lowercased())
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func parse(_ data: Data) {
        let decoder = JSONDecoder()

        if let result = try? decoder.decode(Petitions.self, from: data) {
            allPetitions = result.results
            displayedPetitions = allPetitions
        }

        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedPetitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = displayedPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = "\(petition.signatureCount)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        detailVC.petition = displayedPetitions[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
