//
//  Landmarks.swift
//
//
//  Created by David Ivey on 3/18/16.
//
//

import UIKit

class Landmark: NSObject {
    
    //INITIALIZERS
    init(name: String, desc: String, lat: Double, long: Double) {
        self.name = name
        self.desc = desc
        self.lat = lat
        self.long = long
    }
    
    override init() {
        self.name = ""
        self.desc = ""
        self.lat = 0.0
        self.long = 0.0
    }
    
    //GETTERS
    func getName() -> String {
        return name
    }
    func getDesc() -> String {
        return desc
    }
    func getLat() -> Double{
        return lat
    }
    func getLong() -> Double {
        return long
    }
    
    
    //SETTERS
    func setName(name:String) {
        self.name = name
    }
    func setDesc(desc:String) {
        self.desc = desc
    }
    func setLat(lat: Double) {
        self.lat = lat
    }
    func setLong(long: Double) {
        self.long = long
    }
    
    
    //VARIABLES
    private var name: String
    private var desc: String
    private var lat: Double
    private var long: Double
    
}