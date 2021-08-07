//
//  DetailViewController.swift
//  Project7
//
//  Created by out-usacheva-ei on 01.08.2021.
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
        <style> body { font-size: 125%; } </style>
        </head>
        <body>
        <h2>\(detailItem.title)</h2>
        \(detailItem.body)
        <h5>Signature count: \(detailItem.signatureCount)</h5>
        </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
    }
    

}
