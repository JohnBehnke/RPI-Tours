//
//  JSON_PARSER.swift
//
//
//  Created by David Ivey on 3/18/16.
//
//

import UIKit


import Foundation
//let requestURL: NSURL = NSURL(string: "http://www.learnswiftonline.com/Samples/subway.json")!
//let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
//let session = NSURLSession.sharedSession()
//let task = session.dataTaskWithRequest(urlRequest) {
//    (data, response, error) -> Void in

//    let httpResponse = response as! NSHTTPURLResponse
//    let statusCode = httpResponse.statusCode

//    if (statusCode == 200) {

func jsonParser() -> TourCat {
    var tour_list:[Tour] = []
    
    if let path = NSBundle.mainBundle().pathForResource("Tours", ofType: "json"){
        
        if let jsonData = NSData(contentsOfFile: path){
            //try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
            if let jsonResult = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers){
                if let tours : [AnyObject] = jsonResult["tours"] as? Array{
                    
                    do{
                        var way_list: [Waypoint]
                        var tour_name: String
                        
                        let json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .AllowFragments)
                        
                        if let sub_tour_name = json["name"] as? String {
                            tour_name = sub_tour_name
                        }
                        
                        if let waypoints = json["waypoints"] as? [[String]] {
                            for waypoint in waypoints {
                                way_list.append(Waypoint(lat: Double(waypoint[0])!,long: Double(waypoint[1])!))
                            }
                        }
                        
                        
                        if let landmarks = json["landmarks"] as? [[String]] {
                            for landmark in landmarks {
                                
                                let name = landmark["name"] as? String
                                let description = landmark["description"] as? String
                                let lat = landmark["coordinate"][0] as? Double
                                let long = landmark["coordinate"][1] as? Double
                                
                                land_list.append(Landmark(name, description, lat, long))
                            }
                        }
                        
                        
                        tour_list.append(Tour(tour_name, "" /*this should be description*/, 0 /*distance*/, 0 /*duration*/, way_list, land_list))
                        
                    }
                }
                catch {
                    print("Error with Json: )")
                    
                    
                }
                
                //    }
                
            }
            
            
        }
    }
    return TourCat("" /*this should be the category name*/, "" /*this should be the description*/, tour_list)
    
}