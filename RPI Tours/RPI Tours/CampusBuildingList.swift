//
//  CampusBuildingList.swift
//  RPI Tours
//
//  Created by John Behnke on 4/1/16.
//  Copyright © 2016 RPI Web Tech. All rights reserved.
//


import Foundation
import CSwiftV

struct building {
    var buildingLat:Double
    var buildingLong:Double
    var buildingName:String
   
}


//OH GOD THIS IS TERRBILE. WE WILL REPLACE THIS WAY LATER. PLEASE DEAL WITH IT :(


func buildCSV() -> [building] {
    
    
    
    
    let location = NSBundle.mainBundle().pathForResource("Waypoints", ofType: "csv")
    var stringToParse = try? String(contentsOfFile:location!, encoding: NSUTF8StringEncoding)
    //var stringToParse: String = ""
    
    
    let csv = CSwiftV(String: stringToParse!)
    
    print(csv)
    
    var actualBuildings:[building] = []
    
    for line in csv.rows {
        
        actualBuildings.append(building(buildingLat: Double(line[0])! , buildingLong:  Double(line[1])!, buildingName: line[2]))
    }
    
    return actualBuildings
}






