//
//  ViewController.swift
//  Project6b
//
//  Created by out-usacheva-ei on 28.07.2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label1 = UILabel()
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.backgroundColor = UIColor.red
        label1.text = "THESE"
//      Are all sized to fit their content.
        label1.sizeToFit()

        let label2 = UILabel()
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.backgroundColor = UIColor.cyan
        label2.text = "ARE"
        label2.sizeToFit()

        let label3 = UILabel()
        label3.translatesAutoresizingMaskIntoConstraints = false
        label3.backgroundColor = UIColor.yellow
        label3.text = "SOME"
        label3.sizeToFit()

        let label4 = UILabel()
        label4.translatesAutoresizingMaskIntoConstraints = false
        label4.backgroundColor = UIColor.green
        label4.text = "AWESOME"
        label4.sizeToFit()

        let label5 = UILabel()
        label5.translatesAutoresizingMaskIntoConstraints = false
        label5.backgroundColor = UIColor.orange
        label5.text = "LABELS"
        label5.sizeToFit()

        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
        view.addSubview(label5)

////      Dictionary of the views we want to lay out for VFL.
//        let viewsDictionary = ["label1": label1, "label2": label2, "label3": label3, "label4": label4, "label5": label5]
//
////      It's time for some Visual Format Language!
//        for label in viewsDictionary.keys {
////      Horizontal constraints.
//            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(label)]|", options: [], metrics: nil, views: viewsDictionary))
//        }
//
//        let metrics = ["labelHeight": 88]
////      Vertical constraints.
////      It's the @999 that assigns priority to a given constraint, and using (label1) for the sizes of the other labels is what tells Auto Layout to make them the same height.
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]-(>=10)-|", options: [], metrics: metrics, views: viewsDictionary))
        
//      Auto Layout anchors.
        var previous: UILabel?
        
        for label in [label1, label2, label3, label4, label5] {
            
            label.textAlignment = .center
            
//            label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            
//            label.heightAnchor.constraint(equalToConstant: 88).isActive = true
            label.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2, constant: -10).isActive = true

            if let previous = previous {
//      We have a previous label – create a height constraint.
                label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
            } else {
//      This is the first label.
                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            }
//      Set the previous label to be the current one, for the next loop iteration.
            previous = label
        }
    }

    
}

