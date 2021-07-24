//
//  ViewController.swift
//  Milestone_Project1-3
//
//  Created by out-usacheva-ei on 22.07.2021.
//

import UIKit

class ViewController: UITableViewController {

//      Array of using countries
    var countries = [String]()
    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Countries"
        
//      Interface settings
        tableView.backgroundColor = UIColor.systemGray4
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.barTintColor = UIColor.systemGray4
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.blue]
        
//      Fill the array of countries
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
//      Loading images from file system
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
//        let items = try! fm.contentsOfDirectory(atPath: path)

//      Fill the array of file names
        for country in countries {
            pictures.append("\(path)/\(country).png")
        }
//        print(path)
        print(pictures)
    }

//      For separating cells. Separated cells by sections.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return countries.count
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
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
//      Setting cells and dequeuing cells (delete cells from queue) for optimization.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        cell.imageView?.image = UIImage(named: countries[indexPath.section])
        cell.textLabel?.text = countries[indexPath.section].uppercased()
        cell.textLabel?.textColor = UIColor.blue
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
//      Method for set action for pushed cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//      Loading "Detail View Controller"
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            vc.selectedFlag = countries[indexPath.section]
            vc.pathToImage = pictures[indexPath.section]
//      Show new view
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

