//
//  ViewController.swift
//  Project4
//
//  Created by out-usacheva-ei on 25.07.2021.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

//      Web View
    var webView: WKWebView!
//      Progress View
    var progressView: UIProgressView!
//      Array of allowed websites
    var websites: [String]!
//      Selected website
    var selectedWebsite: String?
    
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
        
        let url = URL(string: "https://" + selectedWebsite!)!
        webView.load(URLRequest(url: url))
        
//      Property in Web View that allows users to swipe from the left
//      or right edge to move backward or forward while browsing the web.
        webView.allowsBackForwardNavigationGestures = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
//      Using KVO for observing value estimatedProgress property of WKWebView. Set self like observer.
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
//      (Progress bar)
        progressView = UIProgressView(progressViewStyle: .default)
//      Setting full size.
        progressView.sizeToFit()
//      Transform view to BarButtonItem.
        let progressButton = UIBarButtonItem(customView: progressView)
        
//      Buttons for toolbar.
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let goBack = UIBarButtonItem(title: "Back", style: .plain, target: webView, action: #selector(webView.goBack))
        let goForward = UIBarButtonItem(title: "Forward", style: .plain, target: webView, action: #selector(webView.goForward))
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        toolbarItems = [goBack, spacer, goForward, spacer, progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
    }
    
//      Setting Alert Action window with style action sheet and variants websites.
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//      Only for iPad
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }

//      Loading url.
    func openPage(action: UIAlertAction) {
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }
    
//      Setting our view controller title property to it would be title of web view.
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
//      Observer method for setting new progress value when estimatedProgress property of WKWebView changed.
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
//      Method for checking that we going to allowed resource.
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
            let ac = UIAlertController(title: "Unallowed URL", message: "You can't go to this URL, sorry.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(ac, animated: true)
        }
        decisionHandler(.cancel)
    }
}

