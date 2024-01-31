//
//  ViewController.swift
//  project7
//
//  Created by Mohammad Eid on 29/01/2024.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Petitions"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let creditsButton = UIButton(type: .infoLight)
        creditsButton.addTarget(self, action: #selector(showCredits), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: creditsButton)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearch))
        
        
        performSelector(inBackground: #selector(fetchJson), with: navigationController?.tabBarItem.tag ?? 0)
    }
    
    @objc func showSearch() {
        let ac = UIAlertController(title: "Search", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Search", style: .default) { [weak self, weak ac] _ in
            if let filterText = ac?.textFields?.first?.text {
                self?.filter(text: filterText)
            }
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func filter(text: String) {
        DispatchQueue.global().async {
            if text.isEmpty {
                self.filteredPetitions = self.petitions
            } else {
                self.filteredPetitions = self.petitions.filter { petition in
                    petition.title.lowercased().contains(text.lowercased())
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Credits", message: "App data is from the \"We The People API\" of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
    
    @objc func fetchJson(tag: Any?) {
        guard let tag = tag as? Int else { return }
        
        let urlString = if tag == 0 {
//            "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
//            "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                self.parse(json: data)
                return
            }
        }
        
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)

    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = petitions
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
//            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    @objc func showError() {
        let ac = UIAlertController(title: "Loading Error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = "\(petition.signatureCount) signatures"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }

    

}

