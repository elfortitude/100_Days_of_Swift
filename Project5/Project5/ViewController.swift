//
//  ViewController.swift
//  Project5
//
//  Created by out-usacheva-ei on 26.07.2021.
//

import UIKit

class ViewController: UITableViewController {

//      All words from file
    var allWords = [String]()
    var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(restartGame))
        
//      Find and open file "start.txt" in file system. Save content in String constant,
//      separate this string by "\n" and save like array of string.
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        startGame()
    }

//      Method for starting and reloading game.
    func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
 
//      Adding answer
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Ener answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
//      Closure for parameter in initializer of UIAlertAction.
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
//      Checking user's input word.
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        let errorTitle: String
        let errorMessage: String
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(lowerAnswer, at: 0)
            
//      Insert cell at begging of Table View with animation ".automatic".
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    return
                } else {
                    errorTitle = "Word not recognised"
                    errorMessage = "You can't just make them up, you know!"
                }
            } else {
                errorTitle = "Word used already"
                errorMessage = "Be more original!"
            }
        } else {
            guard let title = title?.lowercased() else { return }
            errorTitle = "Word not possible"
            errorMessage = "You can't spell that word from \(title)"
        }
        showErrorMessage(errorTitle: errorTitle, errorMessage: errorMessage)
    }

//      Checking that user's answer possible with letters from the given word.
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }

        return true
    }
    
//      Checking that word is not used before.
    func isOriginal(word: String) -> Bool {
        guard let title = title?.lowercased() else { return false }
        
        return !usedWords.contains(word) && !(word == title)
    }
    
//      Checking that world exist. Used UITextChecker.
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let length = word.utf16.count
        let range = NSRange(location: 0, length: length)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound && length >= 3
    }
    
//      Calling Allert Message.
    func showErrorMessage(errorTitle: String, errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
//      Method for restart game.
    @objc func restartGame() {
        let ac = UIAlertController(title: "Restart game", message: "Do you want restart game?", preferredStyle: .alert)
        
        let restartGame = UIAlertAction(title: "Restart", style: .default) { [weak self] action in
            self?.startGame()
        }
        
        ac.addAction(restartGame)
        ac.addAction(UIAlertAction(title: "Don't", style: .cancel))
        present(ac, animated: true)
    }
}

