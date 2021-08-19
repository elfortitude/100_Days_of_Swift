//
//  ViewController.swift
//  Milestone_Projects10-12
//
//  Created by out-usacheva-ei on 17.08.2021.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
//      Array of images with file names and captions.
    var images = [Image]()
    
    var caption = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        if let savedImages = defaults.object(forKey: "images") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                images = try jsonDecoder.decode([Image].self, from: savedImages)
            } catch {
                print("Failed to load images.")
            }
        }
        
        title = "Things"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCapture))
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.blue]
        navigationController?.navigationBar.tintColor = UIColor.blue
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.blue]
    }

//      For separating cells. Separated cells by sections.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return images.count
    }
    
//      Method for set number of rows in section.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
//      For separating cells. Set distance between sections.
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(10)
    }
    
//      For set separator of sections color.
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 10))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
//      Set cell's height.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
//      Method for set action for pushed cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//      Loading "Detail View Controller"
        if let vc = storyboard?.instantiateViewController(identifier: "ImageViewController") as? ImageViewController {
            vc.pathToImage = images[indexPath.section].fileName
            vc.caption = images[indexPath.section].caption
//      Show new scene.
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
//      Setting cells and dequeuing cells (delete cells from queue) for optimization.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let path = getDocumentsDirectory().appendingPathComponent(images[indexPath.section].fileName)
        
        cell.imageView?.image = UIImage(contentsOfFile: path.path)
        cell.textLabel?.text = images[indexPath.section].caption.lowercased()
        cell.textLabel?.textColor = UIColor.blue
//        cell.textLabel?.font = UIFont(name: "TimesNewRoman", size: 16)
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    @objc func addCapture() {
        let ac = UIAlertController(title: "Caption", message: "Add caption", preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            guard let caption = ac?.textFields?[0].text else { return }
            self?.caption = caption
            self?.takePhoto()
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        present(ac, animated: true)
    }

    func takePhoto() {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            ac.addAction(UIAlertAction(title: "Camera", style: .default) { [weak self] action in
                self?.addNewImage()
            })
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
//      Picker Controller with camera source.
    func addNewImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        present(picker, animated: true)
    }
    
//      Take photo and save.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let photo = info[.originalImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = photo.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let image = Image(fileName: imageName, caption: caption)
        images.append(image)
        tableView.reloadData()
        
        dismiss(animated: true)
        save()
    }
    
//      Getting current Document directory path relative to the main app's directoty.
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
//      Save using UserDefault images array in JSON.
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedImages = try? jsonEncoder.encode(images) {
            let defaults = UserDefaults.standard
            defaults.set(savedImages, forKey: "images")
        } else {
            print("Failed to save images.")
        }
    }

}

