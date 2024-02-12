//
//  DetailViewController.swift
//  project16
//
//  Created by Mohammad Eid on 12/02/2024.
//

import UIKit
import WebKit


class WikiViewController: UIViewController {

    var capital: Capital!
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = capital.title
        webView.load(URLRequest(url: capital.wikiPage))

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
