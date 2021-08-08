//
//  ViewController.swift
//  Milestone_Project7-9
//
//  Created by out-usacheva-ei on 08.08.2021.
//

import UIKit

class ViewController: UIViewController {
    
    var lifesLabel: UILabel!
    var currentAnswer: UILabel!
    var letterButtons = [UIButton]()
//      Array with all letters of alphabet.
    var alphabet = [Character]()
//      Array of words from text file.
    var words = [String]()
    var guessWord: String!
//      Array of current characters.
    var currentAnswerArray = [String]()
    
    var activatedButtons = [UIButton]()
    
//      Property observer for update score label everywhere.
    var lifes = 7 {
        didSet {
            lifesLabel.text = "Lifes: \(lifes)"
        }
    }
    
    override func loadView() {
//      General white background.
        view = UIView()
        view.backgroundColor = UIColor.white
        
//      Placing two labels at the top.
        lifesLabel = UILabel()
        lifesLabel.translatesAutoresizingMaskIntoConstraints = false
        lifesLabel.font = UIFont.systemFont(ofSize: 24)
        lifesLabel.textAlignment = .right
        lifesLabel.text = "Lifes: 7"
//        lifesLabel.backgroundColor = UIColor.red
        view.addSubview(lifesLabel)
        
//      Placing label with guess word.
        currentAnswer = UILabel()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.textAlignment = .center
        currentAnswer.text = "?"
//        currentAnswer.backgroundColor = UIColor.blue
        view.addSubview(currentAnswer)
        
//      Adding view container placing user's buttons with parts of answer word.
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.layer.borderWidth = 1
        buttonsView.layer.borderColor = UIColor.gray.cgColor
        view.addSubview(buttonsView)
        
//      Activation constraints.
        NSLayoutConstraint.activate([lifesLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
                                     lifesLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
                                     lifesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.5),
                                    currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                    currentAnswer.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.5),
                                    buttonsView.widthAnchor.constraint(equalToConstant: 900),
                                    buttonsView.heightAnchor.constraint(equalToConstant: 400),
                                    buttonsView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
                                    buttonsView.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor, constant: 50),
                                    buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)])
//      Create 30 buttons as 5x6 grid inside buttonsView.
//      Width of button.
        let width = 150
//      Height of button.
        let height = 80
        
//      Create alphabet array
        let startChar = Unicode.Scalar("A").value
        let endChar = Unicode.Scalar("Z").value
        
        for letter in startChar...endChar {
            if let char = Unicode.Scalar(letter) {
                alphabet.append(Character(char))
            }
        }
        
        for row in 0..<5 {
            for col in 0..<6 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.setTitle((row < 4) ?
                                        String(alphabet[row * 6 + col]) : ((col > 1 && col < 4) ? String(alphabet[row * 6 + col - 2]) : ""), for: .normal)
                
//      Calculating frame of this button.
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        performSelector(inBackground: #selector(loadGame), with: nil)
    }

    @objc func loadGame() {
//      Loading words from file.
        if let gameFileURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let gameContents = try? String(contentsOf: gameFileURL) {
                words = gameContents.components(separatedBy: "\n")
                performSelector(onMainThread: #selector(loadLevel), with: nil, waitUntilDone: false)
                return
            }
        }
        
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    @objc func loadLevel() {
        repeat {
            words.shuffle()
        } while words[0] == ""
        guessWord = words[0].uppercased()
        currentAnswerArray = Array(repeating: "?", count: guessWord.count)
            
        for button in activatedButtons {
            button.isHidden = false
        }
        activatedButtons.removeAll()
            
        currentAnswer.text = currentAnswerArray.joined()
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        
        if guessWord.contains(buttonTitle) {
            for (position, letter) in guessWord.enumerated() {
                if letter == Character(buttonTitle) {
                    currentAnswerArray[position] = String(letter)
                }
            }
        
            currentAnswer.text = currentAnswerArray.joined()
            sender.isHidden = true
            activatedButtons.append(sender)
        } else {
            lifes -= 1
        }
        
        if !currentAnswerArray.contains("?") {
            showMessage(message: "You've won!")
        } else if lifes == 0 {
            showMessage(message: "You've lost")
        }
    }
    
    @objc func showError() {
        let ac = UIAlertController(title: "Loading error", message: nil, preferredStyle: .alert)
        
        present(ac, animated: true)
    }
    
    func showMessage(message: String) {
        let ac = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Start!", style: .default, handler: reloadGame(action:)))
        present(ac, animated: true)
    }
    
    func reloadGame(action: UIAlertAction) {
        lifes = 7
        
        loadLevel()
    }
}

