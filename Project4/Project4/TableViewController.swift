//
//  TableViewController.swift
//  Project4
//
//  Created by out-usacheva-ei on 26.07.2021.
//

import UIKit

class TableViewController: UITableViewController {

//      Array of allowed websites
    var websites = ["mai.ru", "apple.com", "hackingwithswift.com", "vk.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Easy Browser"
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Table view data source

//      Method for set number of rows in table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }

//      Dequeuing cells (delete cells from queue) for optimization.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "website", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = websites[indexPath.row]
        cell.textLabel?.textColor = UIColor.magenta
        
        return cell
    }

//      Method for set action for pushed cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//      Loading "Web View view controller"
        if let vc = storyboard?.instantiateViewController(identifier: "webView") as? ViewController {
            vc.websites = websites
            vc.selectedWebsite = websites[indexPath.row]
//      Show the new view
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}
