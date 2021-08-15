//
//  ViewController.swift
//  Project10
//
//  Created by out-usacheva-ei on 09.08.2021.
//

import UIKit

//      The first of those protocols is useful, telling us when the user either selected
//      a picture or cancelled the picker.
class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        if let savedPeople = defaults.object(forKey: "people") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                people = try jsonDecoder.decode([Person].self, from: savedPeople)
            } catch {
                print("Failed to load people.")
            }
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(choosePhoto))
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell.")
        }
        
        let person = people[indexPath.item]
        
        cell.name.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
//      View Alert Controller with ability of inputting name of person.
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            let secondAC = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .alert)
            
            secondAC.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            secondAC.addAction(UIAlertAction(title: "Sure", style: .default) { [weak self] _ in
                person.name = newName
            
                self?.collectionView.reloadData()
                self?.save()
            })
            
            self?.present(secondAC, animated: true)
        })
        
        present(ac, animated: true)
    }
    
//      Adding new cell with photo.
    func addNewPerson(sourceType: String) {
        let picker = UIImagePickerController()
//      Allow cropping image.
        picker.allowsEditing = true
        picker.delegate = self
        
        if sourceType == "Camera" {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true)
    }
    
    @objc func choosePhoto() {
        let ac = UIAlertController(title: "Choose", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            ac.addAction(UIAlertAction(title: "Camera", style: .default) { [weak self, weak ac] action in
                ac?.dismiss(animated: true) {
                    self?.addNewPerson(sourceType: "Camera")
                }
            })
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            ac.addAction(UIAlertAction(title: "Photo Library", style: .default) { [weak self] action in
                self?.addNewPerson(sourceType: "PhotoLibrary")
            })
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(ac, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView?.reloadData()
        
        dismiss(animated: true)
        save()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(people) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
        } else {
            print("Failed to save people.")
        }
    }
    
}

