//
//  GeneralMapViewController.swift
//  RPI Tours
//
//  Created by John Behnke on 3/16/16.
//  Copyright © 2016 RPI Web Tech. All rights reserved.
//

import UIKit
import Mapbox
import CoreLocation

class GeneralMapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var mapView: MGLMapView!
    var directions: MBDirections?
    override func viewDidLoad() {
        
        let locationManager = CLLocationManager()
        // Ask for Authorisation from the User.
        locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        
        
        
        if CLLocationManager.locationServicesEnabled() {
            
            
            
            

            //BASED GPS TRACKING STUFFFFFFFFFFF
//            let mb = CLLocationCoordinate2D(latitude: 42.72948208, longitude: -73.67905909)
//            let wh = CLLocationCoordinate2D(latitude: 42.728988, longitude: -73.674112)
//            
//            var request = MBDirectionsRequest(sourceCoordinate: mb, waypointCoordinates: [CLLocationCoordinate2D(latitude: 42.73064179, longitude: -73.67553949)], destinationCoordinate: wh)
//            request.transportType = MBDirectionsRequest.MBDirectionsTransportType.Walking
//            directions = MBDirections(request: request, accessToken: mapBoxAPIKey)
//            
//            var test:[CLLocationCoordinate2D] = []
//            var done = true
//            directions!.calculateDirectionsWithCompletionHandler { (response, error) in
//                if let route = response?.routes.first {
//                    print("Route summary:")
//                    print("Distance: \(route.distance) meters (\(route.steps.count) route steps) in \(route.expectedTravelTime / 60) minutes")
//                    for step in route.steps {
//                        //let point = MGLPointAnnotation()
//                        test.append(step.maneuverLocation!)
//                        //self.mapView.addAnnotation(point)
//                        print("\(step.instructions) \(step.distance) meters")
//                    }
//                    let line = MGLPolyline(coordinates: &test, count: UInt(test.count))
//                    
//                    line.title = "Crema to Council Crest"
//                    self.mapView.addAnnotation(line)
//                    done = false
//                } else {
//                    print("Error calculating directions: \(error)")
//                    done = false
//                }
//            }
           
           
        }
        
        
        
        
        super.viewDidLoad()
//        placesClient =
        // Do any additional setup after loading the view, typically from a nib.
        func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
            // Always try to show a callout when an annotation is tapped.
            return true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat {
        // Set the alpha for all shape annotations to 1 (full opacity)
        return 1
    }
    
    func mapView(mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
        // Set the line width for polyline annotations
        return 4.0
    }
    
    func mapView(mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        // Give our polyline a unique color by checking for its `title` property
        if (annotation.title == "Crema to Council Crest" && annotation is MGLPolyline) {
            // Mapbox cyan
            return UIColor(red: 59/255, green:178/255, blue:208/255, alpha:1)
        }
        else
        {
            return UIColor.redColor()
        }
    }
    
    
}
