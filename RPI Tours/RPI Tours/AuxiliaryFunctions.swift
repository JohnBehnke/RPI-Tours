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

                    let newLandmark = Landmark(name: land_name!, desc: land_desc!, lat: land_lat!, long: land_long!, urls: [])

//                    newLandmark.urls = string_land_images

                    land_list.append(newLandmark)
                }
            }
        }
    }
    return land_list
}


func parseTourCategoryJSON(tourCategoryJSON: JSON, completion: @escaping ( _ result: [TourCat]) -> Void ) {

    var cat_list: [TourCat] = []

    for (_, categoryJSON) in tourCategoryJSON["content"] {

        var cat_name: String = ""
        var cat_desc: String = ""

        if let sub_cat_name = categoryJSON["name"].string {
            cat_name = sub_cat_name
        }

        if let sub_cat_desc = categoryJSON["description"].string {
            cat_desc = sub_cat_desc
        }

        print("all Tour part)")
        
        getAllTourForCat(url: Constants.URLS.toursFor(categoryId: categoryJSON["id"].int!), numberOfTours: categoryJSON["numAvailableTours"].int!, completion: { (newList) in
            cat_list.append(TourCat(name: cat_name, desc: cat_desc, tours: newList))

            if cat_list.count == tourCategoryJSON["content"].array?.count{

                completion(cat_list)
            }
        })

    }

}





// Our Tour Category JSON Parser
func getTourCategories(completion: @escaping ( _ result: [TourCat]) -> Void)  {

    let defaults = UserDefaults.standard

    var tourCategoryJSON:JSON?



    if defaults.object(forKey: "lastUpdated") != nil{

        print("Doing local file")
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent("tourCategory.json")

        let rawData = try? String(contentsOf: fileURL)

        tourCategoryJSON = JSON(data: (rawData?.data(using: String.Encoding.utf8))!)
        parseTourCategoryJSON(tourCategoryJSON: tourCategoryJSON!, completion: {(tourCategoryList) in
            completion(tourCategoryList)
        })



    }

    else{

        print("doing Network Call")
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("tourCategory.json")

            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }


        Alamofire.download(Constants.URLS.allCategoriesPath, to: destination).response { response in


            if response.error == nil, let filePath = response.destinationURL?.path {


                let jsonData = try? String(contentsOfFile: filePath, encoding: String.Encoding.utf8)

                if let data = jsonData?.data(using: String.Encoding.utf8) {
                    tourCategoryJSON = JSON(data: data)

                    defaults.set("Hello", forKey: "lastUpdated")
                    parseTourCategoryJSON(tourCategoryJSON: tourCategoryJSON!, completion: {(tourCategoryList) in
                        
                        completion(tourCategoryList)
                    })
                }
            }
        }
    }
}

func parseTourJSON(tourJSON: JSON, numberOfTours: Int, completion: @escaping (_ result : [Tour]) ->Void) {
    var tour_list: [Tour] = []



    for (_, tour) in tourJSON["content"]{


        var land_list: [Landmark] = []
        var way_list: [CLLocationCoordinate2D] = []
        var tour_name: String = ""
        var tour_desc: String = ""

        if let sub_tour_name = tour["name"].string {
            tour_name = sub_tour_name
        }

        if let sub_tour_desc = tour["description"].string {
            tour_desc = sub_tour_desc
        }

        for (_, wayJSON) in tour["waypoints"] {

            way_list.append(CLLocationCoordinate2D(latitude: wayJSON["lat"].double!, longitude: wayJSON["long"].double!))

        }

        for (_, landJSON) in tour["landmarks"] {
            let name = landJSON["name"].string
            let desc = landJSON["description"].string
            let lat = landJSON["lat"].double
            let long = landJSON["long"].double
            var urls: [String] = []

            for (_,part) in (landJSON["photos"]){
                urls.append(part["url"].string!)
            }
            
            land_list.append(Landmark(name: name!, desc: desc!, lat: lat!, long: long!, urls: urls))
        }
//        print(tourJSON)
        tour_list.append(Tour(name: tour_name,
                              desc: tour_desc,
                              waypoints: way_list,
                              landmarks: land_list))
        if tour_list.count == numberOfTours {
            completion(tour_list)
        }
    }
}




func getAllTourForCat(url:String, numberOfTours: Int,completion: @escaping (_ result: [Tour]) -> Void){


    let defaults = UserDefaults.standard
    var tourJSON:JSON?

    if defaults.object(forKey: url) != nil{

        print("REading local tour JSOn")
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent("\(url).json")

        let rawData = try? String(contentsOf: fileURL)

        tourJSON = JSON(data: (rawData?.data(using: String.Encoding.utf8))!)
        parseTourJSON(tourJSON: tourJSON!, numberOfTours: numberOfTours, completion: { (newList) in
            completion(newList)
        })

    }
    else{
        print("Network tour JSOn")
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("\(url).json")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }


        Alamofire.download(url, to: destination).response { response in
            if response.error == nil, let filePath = response.destinationURL?.path{
                let jsonData = try? String(contentsOfFile: filePath, encoding: String.Encoding.utf8)
                if let data = jsonData?.data(using: String.Encoding.utf8){
                    tourJSON = JSON(data: data)
                    defaults.set("Hello", forKey: "\(url)")

                    parseTourJSON(tourJSON: tourJSON!, numberOfTours: numberOfTours, completion: { (newList) in
                        completion(newList)
                    })

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
