//
//  ViewController.swift
//  project4-remake
//
//  Created by Mohammad Eid on 28/01/2024.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var progressBar: UIProgressView!
    var selectedWebsite: String?
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        progressBar = UIProgressView(progressViewStyle: .default)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let selectedWebsite, let url = URL(string: "https://\(selectedWebsite)") {
            webView.load(URLRequest(url: url))
            title = url.host()
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "open", style: .plain, target: self, action: #selector(openWebsites))
        
        // Toolbar config
        navigationController?.isToolbarHidden = false
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: webView, action: #selector(webView.goBack))
        let progressBar = UIBarButtonItem(customView: progressBar)
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let forwardButton = UIBarButtonItem(title: "Forward", style: .plain, target: webView, action: #selector(webView.goForward))
        let spacer = UIBarButtonItem(systemItem: .flexibleSpace)
        toolbarItems = [backButton, spacer, progressBar, spacer, refreshButton, spacer, forwardButton]
        webView.addObserver(self, forKeyPath: "estimatedProgress", context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressBar.progress = Float(webView.estimatedProgress)
        }
    }
    
    
    @objc func openWebsites() {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        for website in Constants.websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openWebsite))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    func openWebsite(_ action: UIAlertAction) {
        if let website = action.title, let url = URL(string: "https://\(website)") {
            webView.load(URLRequest(url: url))
            title = url.host()
        }
    }


}

