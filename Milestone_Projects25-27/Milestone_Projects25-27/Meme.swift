//
//  Meme.swift
//  Milestone_Projects25-27
//
//  Created by out-usacheva-ei on 03.10.2021.
//

import Foundation

class Meme: NSObject, Codable {
    
    var path: String
    var name: String
    
    init(path: String, name: String) {
        self.path = path
        self.name = name
    }
    
}
