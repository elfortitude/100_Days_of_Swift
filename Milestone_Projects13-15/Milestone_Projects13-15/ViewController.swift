//
//  ViewController.swift
//  Milestone_Projects13-15
//
//  Created by out-usacheva-ei on 27.08.2021.
//

import UIKit

class ViewController: UITableViewController {
    
//      Array of countries.
    var countries = [Country]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Countries"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationBar.tintColor = UIColor.systemIndigo
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.systemIndigo]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        
//      Extrating json file.
        if let jsonDataURL = Bundle.main.url(forResource: "countries", withExtension: "json") {
            if let data = try? Data(contentsOf: jsonDataURL) {
                parse(json: data)
                return
            }
        }
        showError()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = countries[indexPath.row].name
        cell.textLabel?.font = UIFont(name: "Menlo", size: 16)
        cell.textLabel?.textColor = UIColor.blue
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = countries[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
//      Parsing JSON to Countries type.
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonCountries = try? decoder.decode(Countries.self, from: json) {
            countries = jsonCountries.results
        }
    }
    
//      Method for showing failure message with using UIAlertController.
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the data; please try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

}

