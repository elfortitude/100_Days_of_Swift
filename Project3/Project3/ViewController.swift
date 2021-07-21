//
//  ViewController.swift
//  Project1
//
//  Created by out-usacheva-ei on 14.07.2021.
//

import UIKit

class ViewController: UITableViewController {
    
//      Array of name of images
    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = UIColor.systemIndigo
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.systemGray]
        
//      Loading images from path ./Content/Content in file system
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        pictures.sort()
        print(pictures)
    }

//      Method for set number of rows in table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pictures.count
    }
    
//      Dequeuing cells (delete cells from queue) for optimization.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

//        To save CPU time and RAM, iOS only creates as many rows as it needs to
//        work. When one rows moves off the top of the screen, iOS will take it away and put
//        it into a reuse queue ready to be recycled into a new row that comes in from the
//        bottom. This means you can scroll through hundreds of rows a second, and iOS can
//        behave lazily and avoid creating any new table view cells – it just recycles the
//        existing ones.
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        cell.textLabel?.textColor = UIColor.systemIndigo
        return cell
    }
   
//      Method for set action for pushed cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//      Loading "Detail View Controller"
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.countOfImages = pictures.count
            vc.numberOfImage = indexPath.row + 1
//      Show new view
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

