//
//  ViewController.swift
//  milestone-project2
//
//  Created by Mohammad Eid on 28/01/2024.
//

import UIKit

class ViewController: UITableViewController {

    var products = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Shopping List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(hanldeAdd))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(handleClear))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "product", for: indexPath)
        cell.textLabel?.text = products[indexPath.row]
        return cell
    }
    
    @objc func hanldeAdd() {
        let ac = UIAlertController(title: "Add Product", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            if let product = ac.textFields?[0].text {
                self?.addProduct(product)
            }
        })
        present(ac, animated: true)
    }
    
    @objc func handleClear() {
        clearProducts()
    }
    
    
    func addProduct(_ product: String) {
        products.insert(product, at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
    
    func clearProducts() {
        var indexPathes = [IndexPath]()
        for i in 0..<products.count {
            indexPathes.append(IndexPath(row: i, section: 0))
        }
        products.removeAll(keepingCapacity: true)
        tableView.deleteRows(at: indexPathes, with: .automatic)
    }


}

