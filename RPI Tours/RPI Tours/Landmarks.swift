//
//  Landmarks.swift
//
//
//  Created by David Ivey on 3/18/16.
//
//

import UIKit
//Inherit wrom Waypoint becuase OOP
class Landmark: Waypoint {
    
    //INITIALIZERS
    init(name: String, desc: String, lat: Double, long: Double) {
        
        self.name = name
        self.desc = desc
        super.init(lat: lat,long: long)
    }
    
    override init() {
        
        self.name = ""
        self.desc = ""
        super.init()
    }
    
    //GETTERS
    func getName() -> String {
        return name
    }
    func getDesc() -> String {
        return desc
    }

    
    
    //SETTERS
    func setName(name:String) {
        self.name = name
    }
    func setDesc(desc:String) {
        self.desc = desc
    }

    
    
    //VARIABLES
    private var name: String
    private var desc: String

    
}