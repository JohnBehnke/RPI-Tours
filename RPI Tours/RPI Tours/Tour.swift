//
//  Tour.swift
//
//
//  Created by David Ivey on 3/18/16.
//
//

import UIKit

class Tour: NSObject {
    
    //INITIALIZERS
    init(name: String, desc: String, distance: Int, duration: Int, waypoints: [Waypoint], landmarks: [Landmark]) {
        self.name = name
        self.desc = desc
        self.distance = distance
        self.duration = duration
        self.waypoints = waypoints
        self.landmarks = landmarks
    }
    
    override init() {
        self.name = ""
        self.desc = ""
        self.distance = 0
        self.duration = 0
        self.waypoints = []
        self.landmarks = []
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
    func getWaypoints() -> [Waypoint]{
        return waypoints
    }
    func getLandmarks()  -> [Landmark]{
        return landmarks
    }
    
    //SETTERS
    func setName(name: String) {
        self.name = name
    }
    func setDesc(desc: String) {
        self.desc = desc
    }
    func setDistance(distance: Int) {
        self.distance = distance
    }
    func setDuration(duration: Int) {
        self.duration = duration
    }
    func setWaypoints(waypoints: [Waypoint]) {
        self.waypoints = waypoints
    }
    func setLandmarks(landmarks: [Landmark]) {
        self.landmarks = landmarks
    }
    
    //VARIABLES
    private var name: String
    private var desc: String
    private var distance: Int
    private var duration: Int
    private var waypoints: [Waypoint]
    private var landmarks: [Landmark]
}