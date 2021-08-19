//
//  ImageViewController.swift
//  Milestone_Projects10-12
//
//  Created by out-usacheva-ei on 18.08.2021.
//

import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    var pathToImage: String?
    var caption: String?

    override func viewDidLoad() {
        super.viewDidLoad()

//      Settings for Navigation Bar.
        title = caption
        navigationItem.largeTitleDisplayMode = .never
    
//      Sharing button.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
//      Show image.
        if let imageToLoad = pathToImage {
            let path = getDocumentsDirectory().appendingPathComponent(imageToLoad)
            imageView.image = UIImage(contentsOfFile: path.path)
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.hidesBarsOnTap = false
    }
    
//      Getting current Document directory path relative to the main app's directoty.
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
//      Method for sharing image.
    @objc func shareTapped() {
        if let imagePath = pathToImage {
            let path = getDocumentsDirectory().appendingPathComponent(imagePath)
            
            let vc = UIActivityViewController(activityItems: [URL(fileURLWithPath: path.path)], applicationActivities: nil)
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
