//
//  ActionViewController.swift
//  Extension
//
//  Created by out-usacheva-ei on 05.09.2021.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    @IBOutlet weak var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""
    
//    var jsSamples = [
//        "alert(document.title)"
//    ]
    
    var website = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(javaScriptSamples))
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
    
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    self!.load()
                    
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                    }
                }
            }
        }
    }

//      Sends the user's JavaScript code for execution.
    @IBAction func done() {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        
        if script.text != "" && !website.contains(script.text) {
            website.append(script.text)
            save()
        }

        extensionContext?.completeRequest(returningItems: [item])
    }
    
//      Processing the keyboard and scrolling in the TextView field.
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }
    
    @objc func javaScriptSamples() {
        
        let ac = UIAlertController(title: "Select sample", message: nil, preferredStyle: .actionSheet)

        for sample in website {
            ac.addAction(UIAlertAction(title: sample, style: .default, handler: { action in
                self.script.text = sample
                self.done()
            }))
        }

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
//      Load user's custom JavaScript script from User Defaults for each other site.
    func load() {
        let defaults = UserDefaults.standard
        
        if let savedData = defaults.object(forKey: (URL(string: pageURL)?.host)! as String) as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                website = try jsonDecoder.decode([String].self, from: savedData)
                if !website.contains("alert(document.title)") {
                    website.append("alert(document.title)")
                }
            } catch {
                print("Failed to load JavaScript information.")
            }
        } else {
            website.append("alert(document.title)")
            print("Failed to load JavaScript information for \(pageURL) site.")
        }

    }
    
//      Save user's custom JavaScript script from User Defaults for each other site.
    func save() {
        let jsonEncoder = JSONEncoder()
        print(website)
        if let savingData = try? jsonEncoder.encode(website) {
            let defaults = UserDefaults.standard
            defaults.set(savingData, forKey: (URL(string: pageURL)?.host)! as String)
            print((URL(string: pageURL)?.host)! as String)
        } else {
            print("Failed to save JavaScripts information.")
        }
    }

}
