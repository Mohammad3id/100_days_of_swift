//
//  ViewController.swift
//  milestone-project5
//
//  Created by Mohammad Eid on 11/02/2024.
//

import UIKit

class ViewController: UITableViewController {
    
    var countries = [Country]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Countries"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        guard let jsonFileURL = Bundle.main.url(forResource: "countries", withExtension: "json") else {
            showAlertError("Couldn't find countries.json file url")
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let data = try Data(contentsOf: jsonFileURL)
            let decodedData = try decoder.decode(Countries.self, from: data)
            countries = decodedData.countries
        } catch {
            showAlertError("Couldn't decode json file", error: error)
            tableView.reloadData()
        }
    }
    
    func showAlertError(_ message: String, error: Error? = nil) {
        print(message)
        if let error {
            print(error)
        }
        
        let ac = UIAlertController(title: "Erro Occured!", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        let country = countries[indexPath.row]
        cell.textLabel?.text = country.name
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailView") as? DetailViewController {
            detailVC.country = countries[indexPath.row]
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

