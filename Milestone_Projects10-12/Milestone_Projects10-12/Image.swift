//
//  Image.swift
//  Milestone_Projects10-12
//
//  Created by out-usacheva-ei on 18.08.2021.
//

import UIKit

class Image: NSObject, Codable {

    var fileName: String
    var caption: String
    
    init(fileName: String, caption: String) {
        self.fileName = fileName
        self.caption = caption
    }
    
}
