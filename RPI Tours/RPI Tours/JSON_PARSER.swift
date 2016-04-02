//
//  JSON_PARSER.swift
//
//
//  Created by David Ivey on 3/18/16.
//
//

import UIKit
import Foundation


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
//            if let landmarks:[AnyObject] = json["tour"]!!["landmarks"] as? Array {
//                for landmark in landmarks {
//                    let name = landmark["name"] as? String
//                    let description = landmark["description"] as? String
//                    let lat = landmark["coordinate"]![0] as? Double
//                    let long = landmark["coordinate"]!![1] as? Double
//                    land_list.append(Landmark(name: name!, desc: description!, lat: lat!, long: long!))
//                }
//                
//            }
            tour_list.append(Tour(name: tour_name, desc: "" /*this should be description*/, distance: 0 /*distance*/, duration: 0 /*duration*/, waypoints: way_list, landmarks: land_list))
        }catch {
            print("Error with Json: )")
        }
    }
    return TourCat(name: "Example" /*this should be the category name*/, desc: "" /*this should be the description*/, tours: tour_list)
}