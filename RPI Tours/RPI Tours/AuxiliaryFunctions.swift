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
import CoreLocation
import Alamofire

//Strct to hold Building info for the map view
struct Building {
    var buildingLat: Double
    var buildingLong: Double
    var buildingName: String
    
}

// Our Landmark Information JSON Parser
func jsonParserLand() -> [Landmark] {
    
    var land_list: [Landmark] = []
    
    let land_file = Bundle.main.path(forResource: "LandmarkInfo", ofType: "json")
    //
    let jsonData = try? String(contentsOfFile: land_file!, encoding: String.Encoding.utf8)
    
    if jsonData != nil {
        do {
            if let data = jsonData?.data(using: String.Encoding.utf8) {
                let json = JSON(data: data)
                
                for (_, landJSON) in json["landmarks"] {
                    
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
                    
                    newLandmark.urls = string_land_images
                    
                    land_list.append(newLandmark)
                }
            }
        }
    }
    return land_list
}

// Our Tour Category JSON Parser
func jsonParserCat(completion: @escaping ( _ result: [TourCat]) -> Void)  {
    
    var cat_list: [TourCat] = []
    
    
    Alamofire.request("http://default-environment.pvwkn4dv9r.us-east-1.elasticbeanstalk.com/api/v1/categories").response { response in
        
        
        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
            print("Data: \(utf8Text)")
            
            let json = JSON(data: data)
            
            for (_, catJSON) in json["content"] {
                
                var cat_name: String = ""
                var cat_desc: String = ""
                
                if let sub_cat_name = catJSON["name"].string {
                    cat_name = sub_cat_name
                }
                
                if let sub_cat_desc = catJSON["description"].string {
                    cat_desc = sub_cat_desc
                }
                
              
                getAllTourForCat(url: "http://default-environment.pvwkn4dv9r.us-east-1.elasticbeanstalk.com/api/v1/categories/\(catJSON["id"])/tours", numberOfTours: catJSON["numAvailableTours"].int!, completion: { (newList) in
                    cat_list.append(TourCat(name: cat_name, desc: cat_desc, tours: newList))
                    if cat_list.count == json["content"].array?.count{
                        print(cat_list[0].tours[0].waypoints)
                        completion(cat_list)
                    }
                })
                
                
                
                
            }
        }
    }
    
    
}


func getAllTourForCat(url:String, numberOfTours: Int,completion: @escaping (_ result: [Tour]) -> Void){
    Alamofire.request(url).response { response2 in
        if let data2 = response2.data,let utf8Text = String(data: data2, encoding: .utf8){
            let json2  = JSON(data:data2)
            var tour_list: [Tour] = []
            
            for (_, tourJSON) in json2["content"] {
                
                var land_list: [Landmark] = []
                var way_list: [CLLocationCoordinate2D] = []
                var tour_name: String = ""
                var tour_desc: String = ""
                
                if let sub_tour_name = tourJSON["name"].string {
                    tour_name = sub_tour_name
                }
                
                if let sub_tour_desc = tourJSON["description"].string {
                    tour_desc = sub_tour_desc
                }
                
                for (_, wayJSON) in tourJSON["waypoints"] {
                    print(wayJSON)
                    way_list.append(CLLocationCoordinate2D(latitude: wayJSON["lat"].double!, longitude: wayJSON["long"].double!))
                    
                }
                
                for (_, landJSON) in tourJSON["landmarks"] {
                    let name = landJSON["name"].string
                    let desc = landJSON["description"].string
                    let lat = landJSON["lat"].double
                    let long = landJSON["long"].double
                    land_list.append(Landmark(name: name!, desc: desc!, lat: lat!, long: long!))
                }
                
                tour_list.append(Tour(name: tour_name,
                                      desc: tour_desc,
                                      waypoints: way_list,
                                      landmarks: land_list))
                if tour_list.count == numberOfTours {
                    completion(tour_list)
                }
            }
        }
        
    }

}


//Build a CSV for our Map screen
//Returns an array of Building structs
func buildCSV() -> [Building] {
    
    //Get the wapoints csv file
    let location = Bundle.main.path(forResource: "Waypoints", ofType: "csv")
    
    let stringToParse = try? String(contentsOfFile:location!, encoding: String.Encoding.utf8)
    
    //Call CSwiftv to parse it
    let csv = CSwiftV(with: stringToParse!)
    
    var actualBuildings: [Building] = []
    
    //Add the Building structs to the array
    for line in csv.rows {
        
        actualBuildings.append(Building(buildingLat: Double(line[0])!,
                                        buildingLong:  Double(line[1])!,
                                        buildingName: line[2]))
    }
    //return it
    
    return actualBuildings
}


//Convert Meters to Feet
func metersToFeet(_ input: Float) -> Float {
    
    return input * 3.28084
}
//Convert seoncds into seconds, hours, adn minutes
func secondsToHoursMinutesSeconds (_ seconds: Double) -> (Double, Double, Double) {
    let (hr, minf) = modf (seconds / 3600)
    let (min, secf) = modf (60 * minf)
    return (hr, min, 60 * secf)
}
