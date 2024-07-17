//
//  DetailViewController.swift
//  Project7
//
//  Created by Franck Kindia on 15/07/2024.
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
        <style> body { font-size: 150%; font-family: "san francisco", "roboto", sans-serif } </style>
        </head>
        <body>
        <h1>\(detailItem.title)</h1>
        <p>\(detailItem.body)</p>
        <p>Signatures: \(detailItem.signatureCount)/100 000</p>
        </body>
        </html>
        """

        webView.loadHTMLString(html, baseURL: nil)
    }


}
