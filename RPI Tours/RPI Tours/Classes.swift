//
//  Classes.swift
//  RPI Tours
//
//  Created by John Behnke on 4/2/17.
//  Copyright © 2017 RPI Web Tech. All rights reserved.
//

import Foundation
import CoreLocation

class TourCat {

    var name: String
    var desc: String
    var tours: [Tour]

    //INITIALIZERS
    init(name: String, desc: String, tours: [Tour]) {
        self.name = name
        self.desc = desc
        self.tours = tours

    }
    //empty Init
    init() {
        self.name = ""
        self.desc = ""
        self.tours = []

    }
}

class Landmark {

    //INITIALIZERS
    init(name: String, desc: String, lat: Double, long: Double, urls: [String]) {

        self.name = name
        self.desc = desc
        self.urls = urls
        self.point = CLLocationCoordinate2D(latitude: lat, longitude: long)

    }

    //VARIABLES
    var name: String
    var desc: String
    var urls: [String]
    var point: CLLocationCoordinate2D

}

class Tour {

    var name: String
    var desc: String
    var waypoints: [CLLocationCoordinate2D]
    var landmarks: [Landmark]

    //INITIALIZERS
    init(name: String, desc: String, waypoints: [CLLocationCoordinate2D], landmarks: [Landmark]) {
        self.name = name
        self.desc = desc
        self.waypoints = waypoints
        self.landmarks = landmarks

    }

    init() {
        self.name = ""
        self.desc = ""
        self.waypoints = []
        self.landmarks = []
    }

}
