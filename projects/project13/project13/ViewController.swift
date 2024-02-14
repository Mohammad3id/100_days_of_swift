//
//  ViewController.swift
//  project13
//
//  Created by Mohammad Eid on 07/02/2024.
//

import CoreImage
import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var intensity: UISlider!
    @IBOutlet var radius: UISlider!
    @IBOutlet var changeFilterButton: UIButton!

    var currentImage: UIImage!

    var context: CIContext!
    var currentFilter: CIFilter!

    let filters = [
        "CIBumpDistortion",
        "CIGaussianBlur",
        "CIPixellate",
        "CISepiaTone",
        "CITwirlDistortion",
        "CIUnsharpMask",
        "CIVignette",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "YACIFP"

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))

//        imageView.alpha = 0
        
        context = CIContext()
        currentFilter = CIFilter(name: filters[0])
        changeFilterButton.setTitle("Filter: \(filters[0])", for: .normal)
    }

    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        dismiss(animated: true)

        currentImage = image

        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            animations: {
                self.imageView.alpha = 0
            },
            completion: { _ in
                let beginImage = CIImage(image: self.currentImage)
                self.currentFilter.setValue(beginImage, forKey: kCIInputImageKey)

                UIView.animate(withDuration: 0.25) {
                    self.imageView.alpha = 1
                }
                
                self.applyProcessing()
            }
        )
        
//        let beginImage = CIImage(image: currentImage)
//        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
//
//        UIView.animate(withDuration: 0.25) {
//            self.imageView.alpha = 1
//        }
//        
//        applyProcessing()
    }

    @IBAction func changeFilter(_ sender: Any) {
        let ac = UIAlertController(title: "Choose Filter", message: nil, preferredStyle: .actionSheet)
        
        for filter in filters {
            ac.addAction(UIAlertAction(title: filter, style: .default, handler: setFilter))
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }

    func setFilter(action: UIAlertAction) {
        guard let actionTitle = action.title else { return }

        changeFilterButton.setTitle("Filter: \(actionTitle)", for: .normal)

        currentFilter = CIFilter(name: actionTitle)

        guard currentImage != nil else { return }

        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)

        applyProcessing()
    }

    @IBAction func save(_ sender: Any) {
        guard let image = imageView.image else {
            let ac = UIAlertController(title: "No image!", message: "Select an image first to be able to save.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
        }

        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        let ac: UIAlertController

        if let error = error {
            ac = UIAlertController(title: "Save error!", message: error.localizedDescription, preferredStyle: .alert)
        } else {
            ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
        }

        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    @IBAction func intensityChanged(_ sender: Any) {
        applyProcessing()
    }

    @IBAction func radiusChanged(_ sender: Any) {
        applyProcessing()
    }

    func applyProcessing() {
        if currentImage == nil { return }
        
        let inputkeys = currentFilter.inputKeys

        if inputkeys.contains(kCIInputIntensityKey) { currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey) }
        if inputkeys.contains(kCIInputAngleKey) { currentFilter.setValue(intensity.value * 3.14 * 4, forKey: kCIInputAngleKey) }
        if inputkeys.contains(kCIInputRadiusKey) { currentFilter.setValue(radius.value * 500, forKey: kCIInputRadiusKey) }
        if inputkeys.contains(kCIInputScaleKey) { currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey) }
        if inputkeys.contains(kCIInputCenterKey) {
            currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey)
        }

        guard let image = currentFilter.outputImage else { return }

        if let cgimg = context.createCGImage(image, from: image.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            imageView.image = processedImage
        }
    }
}
