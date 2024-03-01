//
//  ViewController.swift
//  milestone-project9
//
//  Created by Mohammad Eid on 29/02/2024.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet var editButton: UIButton!
    @IBOutlet var imageView: UIImageView!
    var selectedImage: UIImage?
    
    var topCaption: String?
    var bottomCaption: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        editButton.isHidden = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            systemItem: .add,
            primaryAction: UIAction(handler: addImageTapped)
        )
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            systemItem: .action,
            primaryAction: UIAction(handler: imageActionsTapped)
        )
    }
    
    func imageActionsTapped(_: UIAction) {
        guard let image = imageView.image else { return }
        
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self?.image(_:didFinishSavingWithError:contextInfo:)), nil)
        })
        
        ac.addAction(UIAlertAction(title: "Share", style: .default) { [weak self] _ in
            let activityAC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            self?.present(activityAC, animated: true)
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        let ac = if let error {
            UIAlertController(title: "Save error!", message: error.localizedDescription, preferredStyle: .alert)
        } else {
            UIAlertController(title: "Saved!", message: "Your meme has been saved to your photos.", preferredStyle: .alert)
        }

        ac.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(ac, animated: true)
    }
    
    func addImageTapped(_: UIAction) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        selectedImage = image;
        dismiss(animated: true)
        promptForTopCaption()
    }
    
    func promptForTopCaption() {
        let ac = UIAlertController(title: "Top Caption", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Next", style: .default) { [weak self] _ in
            self?.topCaption = ac.textFields?.first?.text
            self?.promptForBottomCaption()
        })
        present(ac, animated: true)
    }
    
    func promptForBottomCaption() {
        let ac = UIAlertController(title: "Bottom Caption", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Done", style: .default) {[weak self] _ in
            self?.bottomCaption = ac.textFields?.first?.text
            self?.generateMeme()
        })
        present(ac, animated: true)
    }
    
    func generateMeme() {
        guard let selectedImage else { return }
        let renderer = UIGraphicsImageRenderer(size: selectedImage.size)
        let img = renderer.image { ctx in
            selectedImage.draw(in: renderer.format.bounds)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let font = UIFont(name: "Impact", size: 100)!
            let attrs: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.white,
                .strokeColor: UIColor.black,
                .strokeWidth: -5,
                .paragraphStyle: paragraphStyle,
            ]
            
            if let topCaption {
                
                NSAttributedString(string: topCaption, attributes: attrs)
                    .draw(in: CGRect(
                    x: 12,
                    y: 12,
                    width: Int(selectedImage.size.width - 24),
                    height: Int(font.lineHeight * 2 + 24)
                ))
            }
            
            if let bottomCaption {
                var bounds = NSAttributedString(string: bottomCaption, attributes: attrs).boundingRect(
                    with: CGSize(
                        width: selectedImage.size.width - 24,
                        height: selectedImage.size.height
                    ),
                    options: .usesLineFragmentOrigin,
                    context: nil
                )
                
                bounds.origin = CGPoint(
                    x: (selectedImage.size.width - bounds.width) / 2,
                    y: selectedImage.size.height - bounds.height - 12
                )
                
                NSAttributedString(string: bottomCaption, attributes: attrs).draw(in: bounds)
            }
        }
        
        imageView.image = img
        editButton.isHidden = false
    }

    @IBAction func editTapped(_ sender: UIButton) {
        promptForTopCaption()
    }
}

