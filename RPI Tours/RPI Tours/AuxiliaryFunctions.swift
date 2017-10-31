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
import CoreLocation
import Alamofire

//Strct to hold Building info for the map view
struct Building {
    var buildingLat: Double
    var buildingLong: Double
    var buildingName: String

}

struct Tours: Decodable {
    var content: [TourContent]
}

struct TourContent: Decodable {
    var name: String?
    var description: String?
    var waypoints: [TourWaypoint]
    var landmarks: [TourLandmark]
}

struct TourWaypoint: Decodable {
    var lat: Double
    var long: Double
}

struct TourLandmark: Decodable {
    var name: String
    var description: String
    var lat: Double
    var long: Double
    var photos: [TourLandmarkPhotos]
}

struct TourLandmarkPhotos: Decodable {
    var url: String?
}

struct TourCategories: Decodable {
    var content: [TourCategoryContent]
}

struct TourCategoryContent: Decodable {
    var name: String?
    var description: String?
    var id: Int?
    var numAvailableTours: Int?
}

// Our Landmark Information JSON Parser
func jsonParserLand() -> [Landmark] {
    
    struct LandmarkContainer: Decodable {
        let landmarks: [LandmarkInfo]
    }
    struct LandmarkInfo: Decodable {
        let coordinate: [Double]
        let photos: [String]
        let name: String
        let desc: String
    }
    
    var land_list: [Landmark] = []
    
    let land_file = Bundle.main.path(forResource: "LandmarkInfo", ofType: "json")
    
    let data = try? Data(contentsOf: URL(fileURLWithPath: land_file!), options: .uncached)
    
    if data != nil {
        let marks = try? JSONDecoder().decode(LandmarkContainer.self, from: data!)
        
        if marks != nil {
            for l_mark in marks!.landmarks {
                let new_landmark = Landmark(name: l_mark.name, desc: l_mark.desc, lat: l_mark.coordinate[0], long: l_mark.coordinate[1], urls: l_mark.photos)
                
                land_list.append(new_landmark)
            }
            
            return land_list
        }
        
        print("JSON did not contain any information")
    }
    print("JSON file could not be read or does not exist")
    return land_list
}


func parseTourCategoryJSON(tourCategoryJSON: TourCategories, completion: @escaping ( _ result: [TourCat]) -> Void ) {

    var cat_list: [TourCat] = []

    for categoryJSON in tourCategoryJSON.content {

        var cat_name: String = ""
        var cat_desc: String = ""
        
        if let sub_cat_name = categoryJSON.name {
            cat_name = sub_cat_name
        }

        if let sub_cat_desc = categoryJSON.description {
            cat_desc = sub_cat_desc
        }

        print("all Tour part)")
        
        getAllTourForCat(url: Constants.URLS.toursFor(categoryId: categoryJSON.id!), numberOfTours: categoryJSON.numAvailableTours!, completion: { (newList) in
            cat_list.append(TourCat(name: cat_name, desc: cat_desc, tours: newList))

            if cat_list.count == tourCategoryJSON.content.count{

                completion(cat_list)
            }
        })

    }

}





// Our Tour Category JSON Parser
func getTourCategories(completion: @escaping ( _ result: [TourCat]) -> Void)  {

    let defaults = UserDefaults.standard

    var tourCategoryJSON: TourCategories?

    if defaults.object(forKey: "lastUpdated") != nil{

        print("Doing local file")
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent("tourCategory.json")

        let rawData = try? String(contentsOf: fileURL)
        
        let finalData = rawData?.data( using: String.Encoding.utf8 )

        tourCategoryJSON = try? JSONDecoder().decode(TourCategories.self, from: finalData!)
        if tourCategoryJSON != nil {
            parseTourCategoryJSON(tourCategoryJSON: tourCategoryJSON!, completion: {(tourCategoryList) in
                completion(tourCategoryList)
            })
        }


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
                    tourCategoryJSON = try? JSONDecoder().decode(TourCategories.self, from: data)

                    defaults.set("Hello", forKey: "lastUpdated")
                    
                    if tourCategoryJSON != nil {
                        parseTourCategoryJSON(tourCategoryJSON: tourCategoryJSON!, completion: {(tourCategoryList) in
                            
                            completion(tourCategoryList)
                        })
                    }
                }
            }
        }
    }
}

func parseTourJSON(tourJSON: Tours, numberOfTours: Int, completion: @escaping (_ result : [Tour]) ->Void) {
    var tour_list: [Tour] = []



    for (tour) in tourJSON.content{


        var land_list: [Landmark] = []
        var way_list: [CLLocationCoordinate2D] = []
        var tour_name: String = ""
        var tour_desc: String = ""

        if let sub_tour_name = tour.name {
            tour_name = sub_tour_name
        }

        if let sub_tour_desc = tour.description {
            tour_desc = sub_tour_desc
        }

        for (wayJSON) in tour.waypoints {

            way_list.append(CLLocationCoordinate2D(latitude: wayJSON.lat, longitude: wayJSON.long))

        }

        for (landJSON) in tour.landmarks {
            let name = landJSON.name
            let desc = landJSON.description
            let lat = landJSON.lat
            let long = landJSON.long
            var urls: [String] = []

            for (part) in (landJSON.photos){
                urls.append(part.url!)
            }
            
            land_list.append(Landmark(name: name, desc: desc, lat: lat, long: long, urls: urls))
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
    var tourJSON: Tours?

    if defaults.object(forKey: url) != nil{

        print("REading local tour JSOn")
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent("\(url).json")

        let rawData = try? String(contentsOf: fileURL)

        tourJSON = try? JSONDecoder().decode(Tours.self, from: (rawData?.data(using: String.Encoding.utf8))!)
        if tourJSON != nil {
            parseTourJSON(tourJSON: tourJSON!, numberOfTours: numberOfTours, completion: { (newList) in
                completion(newList)
            })
        }
        else {
            print( "Hey the JSON decoding didn't work" )
        }

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
                    tourJSON = try? JSONDecoder().decode(Tours.self, from: data)
                    
                    if tourJSON != nil {
                        defaults.set("Hello", forKey: "\(url)")
                        
                        parseTourJSON(tourJSON: tourJSON!, numberOfTours: numberOfTours, completion: { (newList) in
                            completion(newList)
                        })
                    }
                    else {
                        print( "Hey the JSON decoding didn't work" )
                    }

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
