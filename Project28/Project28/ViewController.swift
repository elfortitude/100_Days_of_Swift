//
//  ViewController.swift
//  Project28
//
//  Created by out-usacheva-ei on 05.10.2021.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    @IBOutlet weak var secret: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nothing to see here"
        
        let notificationCenter = NotificationCenter.default
        
//      Observation for keyboard.
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
//      Observation for change activity and background mode.
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
        
    }

    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        secret.scrollIndicatorInsets = secret.contentInset
        
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }
    
    @objc func saveSecretMessage() {
        guard secret.isHidden == false else { return }
        
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        title = "Nothing to see here"
        navigationItem.rightBarButtonItem = nil
    }
    
    func unlockSecretMessage() {
        secret.isHidden = false
        title = "Secret stuff!"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveSecretMessage))
        
        if let text = KeychainWrapper.standard.string(forKey: "SecretMessage") {
            secret.text = text
        }
    }
    
    func biometryAuth() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                
                DispatchQueue.main.async { [self] in
                    if success {
                        self?.unlockSecretMessage()
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please enter the passcode or try again.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
    
    func passcodeAuth() {
        if let pass = KeychainWrapper.standard.string(forKey: "Passcode") {
            let ac = UIAlertController(title: "Enter passcode", message: nil, preferredStyle: .alert)

            ac.addTextField { textField in
                textField.placeholder = "Passcode"
                textField.isSecureTextEntry = true
            }
            ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
                if (ac?.textFields?[0].hasText)! && (ac?.textFields?[0].text) == pass {
                    self?.unlockSecretMessage()
                } else {
                    self?.passcodeAuth()
                }
            })
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Create passcode", message: nil, preferredStyle: .alert)

            ac.addTextField { textField in
                textField.placeholder = "Passcode"
                textField.isSecureTextEntry = true
//                textField.passwordRules = UITextInputPasswordRules(coder: NSCoder())
            }
            ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
                if let passcode = ac?.textFields?[0].text {
                    KeychainWrapper.standard.set(passcode, forKey: "Passcode")
                } else {
                    self?.passcodeAuth()
                }
            })
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            present(ac, animated: true)
        }
    }
    
    @IBAction func authenticateTapped(_ sender: Any) {
        let ac = UIAlertController(title: "Choose authentication method", message: nil, preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "Biometry", style: .default) { [weak self] _ in
            self?.biometryAuth()
        })
        ac.addAction(UIAlertAction(title: "Passcode", style: .default) { [weak self] _ in
            self?.passcodeAuth()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
}

