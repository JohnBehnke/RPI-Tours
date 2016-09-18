////
////  mapMatchingTest.swift
////  RPI Tours
////
////  Created by John Behnke on 6/12/16.
////  Copyright © 2016 RPI Web Tech. All rights reserved.
////
//
//import Foundation
//import SwiftyJSON
////
////
////
////let parameters = [
////"foo": [1,2,3],
////"bar": [
////"baz": "qux"
////]
////]
////
////Alamofire.request(.POST, "https://httpbin.org/post", parameters: parameters, encoding: .JSON)
//// HTTP body: {"foo": [1, 2, 3], "bar": {"baz": "qux"}}
//
////
////curl -X POST \
////--header "Content-Type:application/json" \
////-d @trace.json \
////"https://api.mapbox.com/matching/v4/mapbox.driving.json"
//
//
//
//
//func smoothPath(input: [[Double]]) -> [[Double]]{
//    let para = [
//        "type": "Feature",
//        "geometry": [
//            "type": "geojson",
//            "coordinates": input
//        ]
//    ]
//    
//    print(input)
//    var x = [AnyObject]()
//    Alamofire.request(.POST, "https://api.mapbox.com/matching/v5/mapbox.walking.json?access_token=\(mapBoxAPIKey)", parameters: para, encoding: .JSON).responseJSON { response in
//        print(response.request)  // original URL request
//       print(response.response) // URL response
//       print(response.data)     // server data
//        //print(response.result)   // result of response serialization
//        
//        if let value = response.result.value {
//            let json = JSON(value)
//            print(json)
//             x = json["features"][0]["properties"]["matchedPoints"].arrayObject!
//            
//            
//            //print("JSON: \(JSON["features"]!!["properties"]!!["matchedPoints"])")
//        }
//    }
//    return (x as? [[Double]])!
//}
