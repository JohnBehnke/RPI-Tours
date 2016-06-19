//
//  AuxiliaryFunctions.swift
//  RPI Tours
//
//  Created by John Behnke on 4/6/16.
//  Copyright © 2016 RPI Web Tech. All rights reserved.
//

import Foundation
import SystemConfiguration
import CSwiftV
import SwiftyJSON

//Strct to hold building info for the map view
struct building {
    var buildingLat:Double
    var buildingLong:Double
    var buildingName:String
    
}

// Our JSON Parser
func jsonParser() -> [TourCat] {

    var cat_list:[TourCat] = []
    let tours_file = NSBundle.mainBundle().pathForResource("Tours", ofType: "json")
    let jsonData = try? String(contentsOfFile: tours_file!, encoding: NSUTF8StringEncoding)
    
    if jsonData != nil {
        
        do {
            
            if let data = jsonData?.dataUsingEncoding(NSUTF8StringEncoding) {
                
                let json = JSON(data: data)
                
                for (_, catJSON) in json["categories"] {
                    
                    var cat_name: String = ""
                    var cat_desc: String = ""
                    var tour_list:[Tour] = []
                    
                    if let sub_cat_name = catJSON["name"].string {
                        cat_name = sub_cat_name
                    }
                    
                    if let sub_cat_desc = catJSON["desc"].string {
                        cat_desc = sub_cat_desc
                    }
                    
                    for (_, tourJSON) in catJSON["tours"] {
                        
                        var land_list:[Landmark] = []
                        var way_list:[tourWaypoint] = []
                        var tour_name: String = ""
                        var tour_desc: String = ""
                        
                        if let sub_tour_name = tourJSON["name"].string {
                            tour_name = sub_tour_name
                        }
                        
                        if let sub_tour_desc = tourJSON["desc"].string {
                            tour_desc = sub_tour_desc
                        }
                        
                        for (_, wayJSON) in tourJSON["waypoints"] {
                            way_list.append(tourWaypoint(lat: Double(wayJSON[0].float!), long: Double(wayJSON[1].float!)))
                        }
                        
                        for (_, landJSON) in tourJSON["landmarks"] {
                            let name = landJSON["name"].string
                            let desc = landJSON["description"].string
                            let lat = (landJSON["coordinate"].array)![0].double
                            let long = (landJSON["coordinate"].array)![1].double
                            land_list.append(Landmark(name: name!, desc: desc!, lat: lat!, long: long!))
                        }
                        
                        tour_list.append(Tour(name: tour_name, desc: tour_desc, distance: 0 /*distance*/, duration: 0 /*duration*/, waypoints: way_list, landmarks: land_list))
                    }
                    
                    cat_list.append(TourCat(name: cat_name, desc: cat_desc, tours: tour_list))
                }
            }
        }
    }
    return cat_list
}

/*
//Determine if we are connected to a network
//Return a bool with status
func isConnectedToNetwork() -> Bool {
    
    var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
    zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
        SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, UnsafePointer($0))
    }
    
    var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
    if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
        return false
    }
    
    let isReachable = flags == .Reachable
    let needsConnection = flags == .ConnectionRequired
    
    return isReachable && !needsConnection
    
    
}
*/

//Build a CSV for our Map screen
//Returns an array of building structs
func buildCSV() -> [building] {
    
    //Get the wapoints csv file
    let location = NSBundle.mainBundle().pathForResource("Waypoints", ofType: "csv")
    
    
    let stringToParse = try? String(contentsOfFile:location!, encoding: NSUTF8StringEncoding)
    
    //Call CSwiftv to parse it
    let csv = CSwiftV(string: stringToParse!)
    
    var actualBuildings:[building] = []
    
    //Add the building structs to the array
    for line in csv.rows {
        
        actualBuildings.append(building(buildingLat: Double(line[0])! , buildingLong:  Double(line[1])!, buildingName: line[2]))
    }
    //return it
    return actualBuildings
}


//Convert Meters to Feet
func metersToFeet(input:Float) -> Float{
    
    return input * 3.28084
}
//Convert seoncds into seconds, hours, adn minutes
func secondsToHoursMinutesSeconds (seconds : Double) -> (Double, Double, Double) {
    let (hr,  minf) = modf (seconds / 3600)
    let (min, secf) = modf (60 * minf)
    return (hr, min, 60 * secf)
}

