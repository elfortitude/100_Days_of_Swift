//
//  WikiViewController.swift
//  Project16
//
//  Created by out-usacheva-ei on 29.08.2021.
//

import UIKit
import WebKit

class WikiViewController: UIViewController, WKNavigationDelegate {
    
//      Web View.
    var webView: WKWebView!
    var capitalName: String?
    var urlString: String?
    
//      Loading view. Before did load view.
    override func loadView() {
        webView = WKWebView()
//      Delegate of WebKit is our class instance.
        webView.navigationDelegate = self
//      Doing our main view - web view.
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = capitalName
        
        guard let url = URL(string: urlString!) else { return }
        webView.load(URLRequest(url: url))
        
//      Property in Web View that allows users to swipe from the left
//      or right edge to move backward or forward while browsing the web.
        webView.allowsBackForwardNavigationGestures = true
    }
    

}
