//
//  ViewController.swift
//  Milestone_Projects19-21
//
//  Created by out-usacheva-ei on 11.09.2021.
//

import UIKit

class ViewController: UITableViewController {
    
    var notes = [Note]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notes 📝"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        
        load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)
        
        cell.textLabel?.text = notes[indexPath.row].title
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        cell.detailTextLabel?.text = notes[indexPath.row].dateOfCreating! + " " + notes[indexPath.row].body!
        cell.detailTextLabel?.textColor = UIColor.systemGray
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        segueToDetailNote(index: indexPath.row)
    }
    
    func segueToDetailNote(index: Int) {
        if let vc = storyboard?.instantiateViewController(identifier: "DetailNote") as? DetailViewController {
            vc.note = notes[index]
            vc.viewController = self
            vc.indexNote = index
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func addNote() {
        let ac = UIAlertController(title: "New note", message: "Enter title of note", preferredStyle: .alert)
        
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            guard let noteTitle = ac?.textFields?[0].text else { return }
            let note = Note(title: noteTitle == "" ? "Unnamed note" : noteTitle, body: "")
            self?.notes.append(note)
            self?.segueToDetailNote(index: self!.notes.count - 1)
        })
        
        present(ac, animated: true)
    }
    
    func load() {
        let defaults = UserDefaults.standard
        
        if let savedData = defaults.object(forKey: "notes") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                notes = try jsonDecoder.decode([Note].self, from: savedData)
            } catch {
                print("Failed to load notes.")
            }
        } else {
            print("Notes are empty.")
        }
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savingData = try? jsonEncoder.encode(notes) {
            let defaults = UserDefaults.standard
            defaults.set(savingData, forKey: "notes")
        } else {
            print("Failed to save notes.")
        }
    }

}

