//
//  DetailViewController.swift
//  project7
//
//  Created by Mohammad Eid on 29/01/2024.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Petition?

    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let detailItem = detailItem else { return }

        let html = """
        <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <style> body { font-size: 150%; } </style>
            </head>
            <body>
                <h4>\(detailItem.title)</h4>
                <h6>\(detailItem.signatureCount) signatures</h6>
                <p>\(detailItem.body)</p>
            </body>
        </html>
        """

        webView.loadHTMLString(html, baseURL: nil)
    }
}
