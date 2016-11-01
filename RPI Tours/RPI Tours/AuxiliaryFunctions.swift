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

// Our Landmark Information JSON Parser
func jsonParserLand() -> [Landmark] {
    
    var land_list:[Landmark] = []
    
    let land_file = NSBundle.mainBundle().pathForResource("LandmarkInfo", ofType: "json")
    
    let jsonData = try? String(contentsOfFile: land_file!, encoding: NSUTF8StringEncoding)
    
    if jsonData != nil {
        do {
            if let data = jsonData?.dataUsingEncoding(NSUTF8StringEncoding) {
                let json = JSON(data: data)
                
                for (_, landJSON) in json["landmarks"] {
                    
                    print("FUCK FUCK FUCK FUCK FUCK FUCK FUCK FUCK FUCK FUCK FUCK FUCK FUCK FUCK FUCK")
                    
                    let land_lat = (landJSON["coordinate"].array)![0].double
                    let land_long = (landJSON["coordinate"].array)![1].double
                    let read_land_images = (landJSON["photos"].array)!
                    let land_name = landJSON["name"].string
                    let land_desc = landJSON["desc"].string
                    
                    var string_land_images: [String] = []
                    
                    for i in read_land_images {
                        string_land_images.append(i.string!)
                    }
                    
                    let newLandmark = Landmark(name: land_name!, desc: land_desc!, lat: land_lat!, long: land_long!)
                    
                    newLandmark.setImages(string_land_images)
                    
                    land_list.append(newLandmark)
                }
            }
        }
    }
    return land_list
}

// Our Tour Category JSON Parser
func jsonParserCat() -> [TourCat] {

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

