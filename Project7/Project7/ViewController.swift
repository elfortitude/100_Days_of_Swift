//
//  ViewController.swift
//  Project7
//
//  Created by out-usacheva-ei on 31.07.2021.
//

import UIKit

class ViewController: UITableViewController {

//      Array of all petitions.
    var petitions = [Petition]()
//      Array of petitions that match the filter.
    var filteredPetitions = [Petition]()
//      Array of petitions to view.
    var viewPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//      Prepare to parsing JSON from whitehouse website API.
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
//            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(creditsTapped))
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filterTapped))
        } else {
//            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                viewPetitions = petitions
                return
            }
        }
        
        showError()
    }
    
//      Parsing JSON to Petitions type.
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }
    
//      Method for showing failure message with using UIAlertController.
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
//      Credits button in Navigation Bar tapped.
    @objc func creditsTapped() {
        let ac = UIAlertController(title: nil, message: "Data comes from the We The People API of the Whitehouse.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(ac, animated: true)
    }
    
//      Filter.
//      Closure for parameter in initializer of UIAlertAction. Adding item in shoppong list.
    @objc func filterTapped() {
        let ac = UIAlertController(title: "Apply filter", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let applyFilter = UIAlertAction(title: "Apply", style: .default) { [weak self, weak ac] action in
            self?.filteredPetitions.removeAll()
            guard let item = ac?.textFields?[0].text else { return }
            if !item.isEmpty {
                for petition in self!.petitions {
                    if petition.title.lowercased().components(separatedBy: " ").contains(item.lowercased()) ||
                        petition.body.lowercased().components(separatedBy: " ").contains(item.lowercased()){
                        self?.filteredPetitions.append(petition)
                    }
                }
                self?.viewPetitions = self!.filteredPetitions
                self?.tableView.reloadData()
            }
        }
        
        let resetFilter = UIAlertAction(title: "Reset", style: .cancel) { [weak self] action in
            self?.viewPetitions = self!.petitions
            self?.tableView.reloadData()
        }
        ac.addAction(applyFilter)
        ac.addAction(resetFilter)
        present(ac, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewPetitions.count
    }
    
//      Cells with disclosure indicator creating.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = viewPetitions[indexPath.row]
//      Title contains name of petition.
        cell.textLabel?.text = petition.title
//      Body contains the first few lines of petition.
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
//      Loading detail View Controller by tapping in cell for description of petition.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = viewPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

