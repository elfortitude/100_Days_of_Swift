//
//  ViewController.swift
//  Milestone_Projects25-27
//
//  Created by out-usacheva-ei on 03.10.2021.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var currentImage: UIImage!
    var currentImageURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Memes Generator"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(chooseImage))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionTapped))
    }
    
    @objc func actionTapped() {
        guard currentImage != nil else {
            print("No image found.")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [currentImageURL!], applicationActivities: [])
        
//      For iPad.
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        currentImage = image
        
        getStrings()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func drawImage(strings: (String?, String?)) {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: currentImage.size.width, height: currentImage.size.height))
        
        let img = renderer.image { context in
            currentImage.draw(at: CGPoint(x: 0, y: 0))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 46),
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.white,
            ]
            
            
            if let topString = strings.0 {
                let attributedString = NSAttributedString(string: topString, attributes: attrs)
                attributedString.draw(at: CGPoint(x: currentImage.size.width / 2 - attributedString.size().width / 2, y: 10))
            }
            
            if let bottomString = strings.1 {
                let attributedString = NSAttributedString(string: bottomString, attributes: attrs)
                attributedString.draw(at: CGPoint(x: currentImage.size.width / 2 - attributedString.size().width / 2, y: currentImage.size.height - 10 - attributedString.size().height))
            }
        }
        
        imageView.image = img
        
        currentImage = img
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        currentImageURL = imagePath
        
        if let jpegData = currentImage.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
    }
    
    @objc func chooseImage() {
        let ac = UIAlertController(title: "Choose", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            ac.addAction(UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
                self?.startImagePickerController(sourceType: "Camera")
            })
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            ac.addAction(UIAlertAction(title: "Photo Library", style: .default) { [weak self] _ in
                self?.startImagePickerController(sourceType: "PhotoLibrary")
            })
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    func startImagePickerController(sourceType: String) {
        let picker = UIImagePickerController()
        
        picker.allowsEditing = true
        picker.delegate = self
        
        if sourceType == "Camera" {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true)
    }
    
    func getStrings() {
        var topString: String?
        var bottomString: String?
        
        let ac = UIAlertController(title: "Enter meme's containt", message: "At the top and at the botton", preferredStyle: .alert)
        
        ac.addTextField { textField in
            textField.placeholder = "Top level"
        }
        ac.addTextField { textField in
            textField.placeholder = "Bottom level"
        }
        
        ac.addAction(UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            topString = ac?.textFields?[0].text
            bottomString = ac?.textFields?[1].text
            self?.drawImage(strings: (topString, bottomString))
        })
        
        present(ac, animated: true)
    }
    
}

