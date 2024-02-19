//
//  ActionViewController.swift
//  Extension
//
//  Created by Mohammad Eid on 16/02/2024.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController {

    @IBOutlet var script: UITextView!

    var pageTitle = ""
    var pageUrl = ""
    
    var scripts = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fm = FileManager()
        for scriptUrl in Bundle.main.urls(forResourcesWithExtension: "js", subdirectory: "Scripts") ?? [] {
            let script = try! String(contentsOf: scriptUrl)
            let scriptName = scriptUrl.lastPathComponent
            scripts[scriptName] = script
        }
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                
                itemProvider.loadItem(forTypeIdentifier: UTType.propertyList.identifier) { [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    
                    let title = javaScriptValues["title"] as? String ?? ""
                    let url = javaScriptValues["URL"] as? String ?? ""
                    
                    self?.pageTitle = title
                    self?.pageUrl = url
                    
                    DispatchQueue.main.async {
                        self?.title = title
                        if let host = URL(string: url)?.host(), let savedScript = UserDefaults.standard.string(forKey: host) {
                            self?.script.text = savedScript
                        }
                    }
                }
            }
        }
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Scripts", style: .plain, target: self, action: #selector(showScripts))
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
//         Get the item[s] we're handling from the extension context.
//        
//         For example, look for an image and place it into an image view.
//         Replace this with something appropriate for the type[s] your extension supports.
//        var imageFound = false
//        for item in self.extensionContext!.inputItems as! [NSExtensionItem] {
//            for provider in item.attachments! {
//                if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
//                    // This is an image. We'll load it, then place it in our image view.
//                    weak var weakImageView = self.imageView
//                    provider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil, completionHandler: { (imageURL, error) in
//                        OperationQueue.main.addOperation {
//                            if let strongImageView = weakImageView {
//                                if let imageURL = imageURL as? URL {
//                                    strongImageView.image = UIImage(data: try! Data(contentsOf: imageURL))
//                                }
//                            }
//                        }
//                    })
//                    
//                    imageFound = true
//                    break
//                }
//            }
//            
//            if (imageFound) {
//                // We only handle one image, so stop looking for more.
//                break
//            }
//        }
    }
    
    @objc func showScripts() {
        let ac = UIAlertController(title: "Scripts", message: nil, preferredStyle: .actionSheet)
        
        for (name, script) in scripts {
            ac.addAction(UIAlertAction(title: name, style: .default) { [weak self] _ in
                self?.script.text = script
            })
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }

    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrome = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrome.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }
    
    @objc func done() {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text ?? ""]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: UTType.propertyList.identifier)
        item.attachments = [customJavaScript]
        
        if let host = URL(string: pageUrl)?.host() {
            UserDefaults.standard.setValue(script.text, forKey: host)
            print("saved")
        }
        
        extensionContext?.completeRequest(returningItems: [item])
    }

}
