//
//  DetailViewController.swift
//  project7-remake
//
//  Created by Mohammad Eid on 02/02/2024.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    var petition: Petition!
    let webView = WKWebView()
    
    override func loadView() {
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let content = """
        <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <style> body { font-size: 150%; } </style>
            </head>
            <body>
                <h4>\(petition.title)</h4>
                <h6>\(petition.signatureCount) signatures</h6>
                <p>\(petition.body)</p>
            </body>
        </html>
        """
        
        webView.loadHTMLString(content, baseURL: nil)
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
