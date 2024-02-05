//
//  ViewController.swift
//  milestone-project4
//
//  Created by Mohammad Eid on 05/02/2024.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var images = [AppImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Images"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImageTapped))
        loadSavedImages()
    }

    func loadSavedImages() {
        let jsonDecoder = JSONDecoder()
        let defaults = UserDefaults.standard
        guard let encodedImages = defaults.object(forKey: "images") as? Data else {
            print("Could not find encoded images data")
            return
        }
        guard let decodedImages = try? jsonDecoder.decode([AppImage].self, from: encodedImages) else {
            print("Could not decode images data")
            return
        }
        
        images = decodedImages
        tableView.reloadData()
    }

    func saveImages() {
        let jsonEncoder = JSONEncoder()
        
        guard let encodedImages = try? jsonEncoder.encode(images) else {
            print("Could not encode images")
            return
        }
        
        let defaults = UserDefaults.standard
        defaults.setValue(encodedImages, forKey: "images")
        
    }

    @objc func addImageTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let pickedImage = info[.editedImage] as? UIImage else { return }

        dismiss(animated: true) { [weak self] in
            let ac = UIAlertController(title: "Image Caption", message: nil, preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac.addAction(UIAlertAction(title: "Save", style: .default) { [weak self, weak ac] _ in
                if let caption = ac?.textFields?.first?.text {
                    self?.addImage(pickedImage, withCaption: caption)
                }
            })
            self?.present(ac, animated: true)
        }
    }

    func addImage(_ image: UIImage, withCaption caption: String) {

        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Couldn't transform image to jpeg")
            return
        }
        
        let imageName = UUID().uuidString
        let imageSavePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        do {
            try imageData.write(to: imageSavePath)
        } catch {
            print("Couldn't save image")
        }
        
        images.insert(AppImage(image: imageName, caption: caption), at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        saveImages()
    }

    func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let image = images[indexPath.row]
        cell.textLabel?.text = image.caption
        let imagePath = getDocumentsDirectory().appendingPathComponent(image.image)
        cell.imageView?.image = UIImage(contentsOfFile: imagePath.path())
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let image = images[indexPath.row]
        if let detailVC = navigationController?.storyboard?.instantiateViewController(withIdentifier: "DetailView") as? DetailViewController {
            detailVC.image = image
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
