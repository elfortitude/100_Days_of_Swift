//
//  DetailViewController.swift
//  Milestone_Project1-3
//
//  Created by out-usacheva-ei on 23.07.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    var selectedFlag: String?
    var pathToImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//      Settings for navigation bar
        title = selectedFlag?.uppercased()
        view.backgroundColor = UIColor.systemGray4
        navigationItem.largeTitleDisplayMode = .never
        
//      Sharing button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
//      Show image
        if let imageToLoad = selectedFlag {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.hidesBarsOnTap = false
    }
    
//      Method for sharing image
    @objc func shareTapped() {
//        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
//            print("No image found")
//            return
//        }
//        print(image)
//        let image = imageView.image?.pngData()
        if let imagePath = pathToImage {
            let vc = UIActivityViewController(activityItems: [URL(fileURLWithPath: imagePath), selectedFlag?.uppercased()], applicationActivities: nil)
            vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
            present(vc, animated: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
