//
//  ViewController.swift
//  Milestone_Project4-6
//
//  Created by out-usacheva-ei on 30.07.2021.
//

import UIKit

class ViewController: UITableViewController {
    
//      Array for items list
    var items = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shopping List"
        
//      Navigation Bar settings.
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = UIColor.systemPurple
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.systemIndigo]
        
//      Toolbar settings.
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        toolbarItems = [spacer, shareButton]
        navigationController?.isToolbarHidden = false
        
//      Buttons for adding itims and remove list in Navigation Bar.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(removeList))
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    @objc func addItem() {
        let ac = UIAlertController(title: "Input item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
//      Closure for parameter in initializer of UIAlertAction. Adding item in shoppong list.
        let addItemAction = UIAlertAction(title: "ADD", style: .default) { [weak self, weak ac] action in
            guard let item = ac?.textFields?[0].text else { return }
            self?.items.append(item)
            let indexPath = IndexPath(row: (self?.items.count ?? 0) - 1, section: 0)
            self?.tableView.insertRows(at: [indexPath], with: .automatic)
        }
        
        ac.addAction(addItemAction)
        present(ac, animated: true)
    }
    
//      Remove list with using UIAlertAction like before.
    @objc func removeList() {
        let ac = UIAlertController(title: "Remove list", message: "Are you sure?", preferredStyle: .alert)
        let removeAction = UIAlertAction(title: "Remove", style: .default) { [weak self] action in
            self?.items.removeAll()
            self?.tableView.reloadData()
        }
        
        ac.addAction(removeAction)
        ac.addAction(UIAlertAction(title: "Don't", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func shareTapped() {
        let list = items.joined(separator: "\n")
        let vc = UIActivityViewController(activityItems: [list], applicationActivities: [])

//      Need only for iPad.
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(vc, animated: true)
    }

}

