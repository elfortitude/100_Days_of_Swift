//
//  ViewController.swift
//  Project2
//
//  Created by out-usacheva-ei on 17.07.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
//      Array of using countries
    var countries = [String]()
    var correctAnswer = 0
    var score = 0
    var countRounds = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//      Fill the countries array
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
//      Set frame around images
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.blue.cgColor
        button2.layer.borderColor = UIColor.blue.cgColor
        button3.layer.borderColor = UIColor.blue.cgColor
        
        askQuestion()
    }

//      For showing three random images
    func askQuestion(action: UIAlertAction! = nil) {
//      In-place shuffling
        countries.shuffle()
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        correctAnswer = Int.random(in: 0...2)
        title = "\(countries[correctAnswer].uppercased()) \(score)"
    }
    
//    Processing after pushing button with flag
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        var message = ""
        var actionTitle: String
        
        countRounds += 1
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong"
            score -= 1
        }
        
//      Restart game when rounds == 10
        if countRounds == 10 {
            message = "This is final. Your score is \(score)"
            actionTitle = "Restart"
            score = 0
            countRounds = 0
        } else {
            if title == "Wrong" {
                message = "This is \(countries[sender.tag].uppercased()). "
            }
            message += "Your score is \(score)"
            actionTitle = "Continue"
        }

//      Alert message with one button
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: actionTitle, style: .default, handler: askQuestion))
        present(ac, animated: true)
    }
}

