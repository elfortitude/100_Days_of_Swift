//
//  Country.swift
//  Milestone_Projects13-15
//
//  Created by out-usacheva-ei on 27.08.2021.
//

import Foundation

struct Country: Codable {
    var name: String
    var capital: String
    var square: Double
    var population: Int
    var currency: String
    var facts: [String]
}
