//
//  DetailViewController.swift
//  Milestone_Projects13-15
//
//  Created by out-usacheva-ei on 28.08.2021.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    var webView: WKWebView!
    var detailItem: Country?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let item = detailItem else { return }
        
        title = item.name
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        var html = """
        <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <style> body { font-size: 125%; } </style>
            </head>
            <body>
                <h3>Capital city</h3>
                \(item.capital)
                <h3>Square</h3>
                \(Int(item.square))
                <h3>Population</h3>
                \(item.population)
                <h3>Currency</h3>
                \(item.currency)
                <h3>Interesting facts</h3>
        """
        
        for i in 0..<item.facts.count {
            html += "<h4>\(i + 1)</h4> \(item.facts[i])"
        }
        
        html += """
            </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
    }
    
//      Method for sharing information
    @objc func shareTapped() {
        let vc = UIActivityViewController(activityItems: [detailItem?.name, detailItem?.capital], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

}
