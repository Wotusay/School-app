//
//  SchoolMapAnnotation.swift
//  NYCSchools
//
//  Created by Wout Salembier on 03/01/2024.
//

import Foundation
import MapKit

class SchoolMapAnnotation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var subtitle: String?

    init(title: String, coordinate: CLLocationCoordinate2D, subtitle: String) {
        self.title = title
        self.coordinate = coordinate
        self.subtitle = subtitle
    }
}
