//
//  Waypoints.swift
//
//
//  Created by David Ivey on 3/18/16.
//
//

import UIKit

class Waypoint {
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
    func getLong()  -> Double {
        return long
    }
    
    //SETTERS
    func setLat(lat: Double) {
        self.lat = lat
    }
    func setLong(long: Double) {
        self.long = long
    }
    
    private var lat: Double
    private var long: Double
}