//
//  Capital.swift
//  Project16
//
//  Created by out-usacheva-ei on 28.08.2021.
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var wiki: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, wiki: String) {
        self.title = title
        self.coordinate = coordinate
        self.wiki = wiki
    }
}
