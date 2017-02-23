//
//  Waypoints.swift
//
//
//  Created by David Ivey on 3/18/16.
//
//

import UIKit

class TourWaypoint {
    //INITIALIZERS
    init(lat: Double, long: Double) {
        self.lat = lat
        self.long = long
    }

     init() {
        self.lat = 0.0
        self.long = 0.0
    }

    //GETTERS
    func getLat() -> Double {
        return lat
    }
    func getLong() -> Double {
        return long
    }

    //SETTERS
    func setLat(_ lat: Double) {
        self.lat = lat
    }
    func setLong(_ long: Double) {
        self.long = long
    }

    fileprivate var lat: Double
    fileprivate var long: Double
}
