//
//  Note.swift
//  Milestone_Projects19-21
//
//  Created by out-usacheva-ei on 12.09.2021.
//

import Foundation

class Note: NSObject, Codable {
    
    var title: String?
    var body: String?
    var dateOfCreating: String?
    
    init(title: String, body: String) {
        super.init()
        self.title = title
        self.body = body
        self.dateOfCreating = self.dateFormatting()
    }
    
    func dateFormatting() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        return dateFormatter.string(from: date)
    }
}
