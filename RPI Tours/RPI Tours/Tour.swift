//
//  Tour.swift
//
//
//  Created by David Ivey on 3/18/16.
//
//

import UIKit
import CoreLocation

class Tour {
    
    //INITIALIZERS
    init(name: String, desc: String, distance: Int, duration: Int, waypoints: [tourWaypoint], landmarks: [Landmark]) {
        self.name = name
        self.desc = desc
        self.distance = distance
        self.duration = duration
        self.waypoints = waypoints
        self.landmarks = landmarks
        self.hasTaken = false

    }
    
     init() {
        self.name = ""
        self.desc = ""
        self.distance = 0
        self.duration = 0
        self.waypoints = []
        self.landmarks = []
        self.hasTaken = false
    }
    
    //GETTERS
    func getName() -> String {
        return name
    }
    func getDesc() -> String  {
        return desc
    }
    func getDistance() -> Int {
        return distance
    }
    func getDuration() -> Int {
        return duration
    }
    //Returns waypoints in the form of CLLocationCoordinate2D for easier working with MapBox
    func getWaypoints() -> [CLLocationCoordinate2D]{
        var retArray:[CLLocationCoordinate2D] = []
        for point in waypoints{
            retArray.append(CLLocationCoordinate2D(latitude: point.getLat(), longitude: point.getLong()))
        }
        return retArray
    }
    
    
    func getLandmarks()  -> [Landmark]{
        return landmarks
    }
    
    //SETTERS
    func setName(_ name: String) {
        self.name = name
    }
    func setDesc(_ desc: String) {
        self.desc = desc
    }
    func setDistance(_ distance: Int) {
        self.distance = distance
    }
    func setDuration(_ duration: Int) {
        self.duration = duration
    }
    func setWaypoints(_ waypoints: [tourWaypoint]) {
        self.waypoints = waypoints
    }
    func setLandmarks(_ landmarks: [Landmark]) {
        self.landmarks = landmarks
    }
    
    func setHasTaken(_ input:Bool) {
        self.hasTaken = input
    }
    
    //VARIABLES
    fileprivate var name: String
    fileprivate var desc: String
    fileprivate var distance: Int
    fileprivate var duration: Int
    fileprivate var waypoints: [tourWaypoint]
    fileprivate var landmarks: [Landmark]
    fileprivate var  hasTaken: Bool
}
