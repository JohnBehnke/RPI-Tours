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

//Our JSON Parser
func jsonParser() -> [TourCat] {
    var cat_list:[TourCat] = []
    let tours_file = NSBundle.mainBundle().pathForResource("Tours", ofType: "json")
    let jsonData = NSData(contentsOfFile: tours_file!)
    if jsonData != nil{
        //if let tours : [AnyObject] = jsonData["tours"] as? Array{
        do{
            
            
            
            
            let json = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: .MutableContainers)
            
            if let cats:[AnyObject] = json["categories"] as? Array {

                for cat in cats {
                    var cat_name: String = ""
                    var cat_desc = ""
                    var tour_list:[Tour] = []
                    if let sub_cat_name = cat["name"] as? String {
                        cat_name = sub_cat_name
                    }
                    if let sub_cat_desc = cat["desc"] as? String {
                        cat_desc = sub_cat_desc
                    }
                    
                    if let tours:[AnyObject] = cat["tours"] as? Array {
                        for tour in tours {
                            var land_list:[Landmark] = []
                            var way_list: [Waypoint] = []
                            var tour_name: String = ""
                            var tour_desc: String = ""
                            if let sub_tour_name = tour["name"] as? String {
                                tour_name = sub_tour_name
                            }
                            if let sub_tour_desc = tour["desc"] as? String {
                                tour_desc = sub_tour_desc
                            }
                            if let waypoints:[[Float]] = tour["waypoints"] as? Array {
                                for waypointt in waypoints {
                                    way_list.append(Waypoint(lat: Double(waypointt[0]), long: Double(waypointt[1])))
                                }
                            }
                            if let landmarks:[Dictionary<String,AnyObject>] = tour["landmarks"] as? Array {
                                for landmark in landmarks {
                                    let name = landmark["name"] as? String
                                    let description = landmark["description"] as? String
                                    let lat = (landmark["coordinate"] as? Array)![0] as Double
                                    let long = (landmark["coordinate"] as? Array)![1] as Double
                                    land_list.append(Landmark(name: name!, desc: description!, lat: lat, long: long))
                                }
                                
                            }
                            tour_list.append(Tour(name: tour_name, desc: tour_desc, distance: 0 /*distance*/, duration: 0 /*duration*/, waypoints: way_list, landmarks: land_list))
                        }
                    }
                    cat_list.append(TourCat(name: cat_name, desc: cat_desc, tours: tour_list) )
                }
                
            }
            
            
            
        }catch {
            print("Error with Json: )")
        }
    }
    return cat_list
}

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


//Build a CSV for our Map screen
//Returns an array of building structs
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


//Convert Meters to Feet
func metersToFeet(input:Float) -> Float{
    
    return input * 3.28084
}

