//
//  ViewController.swift
//  Milestone_Projects28-30
//
//  Created by Elizaveta Usacheva on 24.10.2021.
//

import UIKit

class ViewController: UIViewController {
    
    var mainLabel: UILabel!
    var scoreLabel: UILabel!
    var cardsButtons = [UIButton: String]()
    var activatedButtons = [UIButton]()
    var currentlyButton: UIButton?
    
//      Property observer for update score label everywhere.
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func loadView() {
//      General white background.
        view = UIView()
//        view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpeg")!)
        view.backgroundColor = .blue
        
//      Placing labels.
        mainLabel = UILabel()
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.font = UIFont.systemFont(ofSize: 36)
        mainLabel.textAlignment = .center
        mainLabel.textColor = .white
        mainLabel.text = "Find pairs"
        view.addSubview(mainLabel)
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.textColor = .white
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadGame()
    }
    
    @objc func loadGame() {
        score = 0
//      Adding view container for placing buttons with pairs.
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
//        buttonsView.layer.borderWidth = 1
//        buttonsView.layer.borderColor = UIColor.black.cgColor
        view.addSubview(buttonsView)
                
//      Activation constraints.
        NSLayoutConstraint.activate([mainLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 25),
                                    mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                    scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
                                    scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
                                    buttonsView.widthAnchor.constraint(equalToConstant: 1000),
                                    buttonsView.heightAnchor.constraint(equalToConstant: 650),
                                    buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                    buttonsView.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 50)])
                
//      Create 20 buttons as 4x5 grid inside buttonsView.
//      Width of button.
        let width = 100
//      Height of button.
        let height = 150
                
//      Counting of free cards.
        var counter = [Int: Int]()
        for i in 5...14 {
            counter[i] = 2
        }
        for row in 0..<4 {
            for col in 0..<5 {
                let cardButton = UIButton(type: .custom)
                cardButton.setImage(UIImage(named: "back.png"), for: .normal)
                        
//      Calculating frame of this button.
                let frame = CGRect(x: col * width + 125 * col, y: row * height + 10 * row, width: width, height: height)
                cardButton.frame = frame
                        
                buttonsView.addSubview(cardButton)
                cardButton.addTarget(self, action: #selector(cardTapped), for: .touchUpInside)
                        
//      Set nominal value.
//      Nominal.
                var randomValue1 = Int.random(in: 5...14)
                while !counter.keys.contains(randomValue1) {
                    randomValue1 = Int.random(in: 5...14)
                }
//      Suit.
                let randomValue2 = Int.random(in: 1...4)
                cardsButtons[cardButton] = "\(randomValue1)_\(randomValue2)"
                counter[randomValue1]! -= 1
                if counter[randomValue1] == 0 {
                    counter[randomValue1] = nil
                }
            }
        }
    }

    @objc func cardTapped(_ sender: UIButton) {
        if currentlyButton == nil {
            currentlyButton = sender
            sender.setImage(UIImage(named: "\(self.cardsButtons[sender]!).png"), for: .normal)
            UIView.transition(with: sender, duration: 1, options: .transitionFlipFromRight, animations: nil, completion: nil)
            sender.isUserInteractionEnabled = false
        } else {
            self.view.isUserInteractionEnabled = false
            sender.setImage(UIImage(named: "\(cardsButtons[sender]!).png"), for: .normal)
            UIView.transition(with: sender, duration: 1, options: .transitionFlipFromRight, animations: nil) { [weak self] _ in
                let firstCard = self?.cardsButtons[sender]!.components(separatedBy: "_")
                let secondCard = self?.cardsButtons[(self?.currentlyButton!)!]!.components(separatedBy: "_")
                if Int((firstCard?[0])!) == Int(secondCard![0]) {
                    sender.isUserInteractionEnabled = false
                    self?.activatedButtons.append((self?.currentlyButton!)!)
                    self?.activatedButtons.append(sender)
                    self?.view.isUserInteractionEnabled = true
                    self?.score += 2
                } else {
                    self?.currentlyButton?.setImage(UIImage(named: "back.png"), for: .normal)
                    UIView.transition(with: (self?.currentlyButton!)!, duration: 1, options: .transitionFlipFromRight, animations: nil, completion: nil)
                    self?.currentlyButton?.isUserInteractionEnabled = true
                    sender.setImage(UIImage(named: "back.png"), for: .normal)
                    UIView.transition(with: sender, duration: 1, options: .transitionFlipFromRight, animations: nil, completion: nil)
                    sender.isUserInteractionEnabled = true
                    self?.view.isUserInteractionEnabled = true
                    self?.score -= 1
                }
                self?.currentlyButton = nil
                if self?.activatedButtons.count == 20 {
                    self?.wonGame()
                } else if self!.score <= -10 {
                    self?.failedGame()
                }
            }
        }
    }
    
    func wonGame() {
        let ac = UIAlertController(title: "You won!", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Restart", style: .default) { [weak self] _ in
            self!.reloadGame()
        })
        present(ac, animated: true)
    }
    
    func failedGame() {
        let ac = UIAlertController(title: "You failed!", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Restart!", style: .default) { [weak self] _ in
            self!.reloadGame()
        })
        present(ac, animated: true)
    }
    
    func reloadGame() {
        for button in cardsButtons {
            button.key.removeFromSuperview()
        }
        activatedButtons.removeAll()
        cardsButtons.removeAll()
        loadGame()
    }

}

