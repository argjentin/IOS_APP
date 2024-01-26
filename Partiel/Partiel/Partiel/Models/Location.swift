//
//  Location.swift
//  Partiel
//
//  Created by jobst gaetan on 11/12/2023.
//

import Foundation
import CoreLocation

struct Place: Identifiable, Codable, Hashable{
    var id: Int
    var longitude: Double
    var latitude: Double
    var name: String
    var description: String
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
    }
}
