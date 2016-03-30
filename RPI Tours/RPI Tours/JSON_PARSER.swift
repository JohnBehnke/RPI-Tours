//
//  JSON_PARSER.swift
//  
//
//  Created by David Ivey on 3/18/16.
//
//

import UIKit
import SwiftyJSON


//let requestURL: NSURL = NSURL(string: "http://www.learnswiftonline.com/Samples/subway.json")!
//let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
//let session = NSURLSession.sharedSession()
//let task = session.dataTaskWithRequest(urlRequest) {
//    (data, response, error) -> Void in

//    let httpResponse = response as! NSHTTPURLResponse
//    let statusCode = httpResponse.statusCode

//    if (statusCode == 200) {

if let path = Bundle.mainBundle().pathForResource("Tours", ofType: "json"){
        if let jsonData = Data(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil){
            if let jsonResult: Dictionary = JSONSerialization.JSONObjectWithData(jsonData, options: JSONReadingOptions.MutableContainers, error: nil) as? Dictionary{
                if let tours : Array = jsonResult["tours"] as? Object{
                    
                    
                    
                    
                }
            }
        }
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        do{
            
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            
            if let sub_tour_name = json["name"] as? [[String: Array]] {
                tours.append(sub_tour_name)
            }
            
            if let waypoints = json["waypoints"] as? [[String: Array]] {
                for waypoint in waypoints {
                    waypoints.append(waypoint)
                }
            }
            
            
            if let landmarks = json["landmarks"] as? [[String: Array]] {
                for landmark in landmarks {
                    if let name = landmark["name"] as? String {
                        names.append(name)
                    }
                    if let description = landmark["description"] as? String {
                        descriptions.append(description)
                    }
//                    if let photo = landmark["photos"] as? String {
//                        photos.append(photo)
//                    }
                    if let coordinate = landmark["coordinate"] as? Float {
                        coordinates.append(coordinate)
                    }
                }
            }
            
            
        }catch {
            print("Error with Json: \(error)")
            
        }
        
//    }

//}

task.resume()