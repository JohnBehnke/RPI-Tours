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




struct building {
    var buildingLat:Double
    var buildingLong:Double
    var buildingName:String
    
}

func jsonParser() -> TourCat {
    var tour_list:[Tour] = []
    let tours_file = NSBundle.mainBundle().pathForResource("Tours", ofType: "json")
    let jsonData = NSData(contentsOfFile: tours_file!)
    if jsonData != nil{
        //if let tours : [AnyObject] = jsonData["tours"] as? Array{
        do{
            var way_list: [Waypoint] = []
            var tour_name: String = ""
            var land_list:[Landmark] = []
            let json = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: .MutableContainers)
            if let sub_tour_name = json["tour"]!!["name"] as? String {
                tour_name = sub_tour_name
            }
            if let waypoints:[[Float]] = json["tour"]!!["waypoints"] as? Array {
                for waypointt in waypoints {
                    way_list.append(Waypoint(lat: Double(waypointt[0]), long: Double(waypointt[1])))
                }
            }
            if let landmarks:[Dictionary<String,AnyObject>] = json["tour"]!!["landmarks"] as? Array {
                for landmark in landmarks {
                    let name = landmark["name"] as? String
                    let description = landmark["description"] as? String
                    let lat = (landmark["coordinate"] as? Array)![0] as Double
                    let long = (landmark["coordinate"] as? Array)![1] as Double
                    land_list.append(Landmark(name: name!, desc: description!, lat: lat, long: long))
                }
                
            }
            tour_list.append(Tour(name: tour_name, desc: "Hey! This is an example tour brought to you by the RPI Tours SD&D team!" /*this should be description*/, distance: 0 /*distance*/, duration: 0 /*duration*/, waypoints: way_list, landmarks: land_list))
        }catch {
            print("Error with Json: )")
        }
    }
    return TourCat(name: "Example Tour Category" /*this should be the category name*/, desc: "Hey, this is a demo tour category for SD&D. It has a single tour that goes around campus!" /*this should be the description*/, tours: tour_list)
}


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



func buildCSV() -> [building] {
    
    
    let location = NSBundle.mainBundle().pathForResource("Waypoints", ofType: "csv")
    let stringToParse = try? String(contentsOfFile:location!, encoding: NSUTF8StringEncoding)
    
    
    let csv = CSwiftV(String: stringToParse!)
    
    var actualBuildings:[building] = []
    
    for line in csv.rows {
        
        actualBuildings.append(building(buildingLat: Double(line[0])! , buildingLong:  Double(line[1])!, buildingName: line[2]))
    }
    
    return actualBuildings
}

func metersToFeet(input:Float) -> Float{
    
    return input * 3.28084
}

