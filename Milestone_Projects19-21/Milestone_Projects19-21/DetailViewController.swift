//
//  DetailViewController.swift
//  Milestone_Projects19-21
//
//  Created by out-usacheva-ei on 12.09.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var text: UITextView!
    
    var note: Note?
    var indexNote: Int?
    var viewController: ViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = note?.title
        
        text.text = note?.body
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
        
//      Toolbar settings.
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        toolbarItems = [spacer, shareButton]
        navigationController?.isToolbarHidden = false
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewController?.navigationController?.isToolbarHidden = true
    }

//      Processing the keyboard and scrolling in the TextView field.
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            viewController?.notes[indexNote!].body = text.text
            viewController?.save()
            text.contentInset = .zero
        } else {
            text.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        text.scrollIndicatorInsets = text.contentInset
        
        let selectedRange = text.selectedRange
        text.scrollRangeToVisible(selectedRange)
    }
    
    @objc func deleteNote() {
        let ac = UIAlertController(title: "Delete note", message: "Are you sure?", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "NO", style: .cancel))
        ac.addAction(UIAlertAction(title: "YES", style: .default) { [weak self] _ in
            self?.viewController?.notes.remove(at: (self?.indexNote)!)
            self?.viewController?.save()
            self?.navigationController?.popToRootViewController(animated: true)
        })
        
        present(ac, animated: true)
    }
    
    @objc func shareTapped() {
        let sharingNote = note!.title! + "\n" + note!.body!
        let vc = UIActivityViewController(activityItems: [sharingNote], applicationActivities: [])
        
//      Need only for iPad.
        vc.popoverPresentationController?.barButtonItem = toolbarItems?.last
        
        present(vc, animated: true)
    }
    
}
