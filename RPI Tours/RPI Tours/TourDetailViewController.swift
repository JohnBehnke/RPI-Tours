//
//  TourDetailViewController.swift
//  RPI Tours
//
//  Created by John Behnke on 3/26/16.
//  Copyright © 2016 RPI Web Tech. All rights reserved.
//

import UIKit
import Mapbox
import CoreLocation

class TourDetailViewController: UIViewController , CLLocationManagerDelegate  {
    
    var actualTour:Tour = Tour()
    var directions: MBDirections?
    let locationManager = CLLocationManager()
    
    @IBOutlet  var mapView: MGLMapView!
    
    @IBOutlet var topNagivationItem: UINavigationItem!
    
    
    @IBOutlet var tourDescriptionTextBox: UILabel!
    
    
    @IBOutlet var startTourButton: UIButton!
    
    
    @IBOutlet var tourStatsLabel: UILabel!
    
    
    override func viewDidLoad() {
        
        var workingWapoints:[CLLocationCoordinate2D] = actualTour.getWaypoints()
//        let mb = CLLocationCoordinate2D(latitude: actualTour.getWaypoints()[0].getLat(), longitude: actualTour.getWaypoints()[0].getLong())
//        let wh = CLLocationCoordinate2D(latitude: actualTour.getWaypoints()[actualTour.getWaypoints().count - 1].getLat(), longitude: actualTour.getWaypoints()[actualTour.getWaypoints().count - 1].getLong())
        
        var request = MBDirectionsRequest(sourceCoordinate: workingWapoints.removeFirst() , waypointCoordinates:workingWapoints, destinationCoordinate: workingWapoints.removeLast())
        request.transportType = MBDirectionsRequest.MBDirectionsTransportType.Walking
        directions = MBDirections(request: request, accessToken: mapBoxAPIKey)
        
        var test:[CLLocationCoordinate2D] = []
        var done = true
        directions!.calculateDirectionsWithCompletionHandler { (response, error) in
            if let route = response?.routes.first {
                print("Route summary:")
                print("Distance: \(route.distance) meters (\(route.steps.count) route steps) in \(route.expectedTravelTime / 60) minutes")
                for step in route.steps {
                    //let point = MGLPointAnnotation()
                    test.append(step.maneuverLocation!)
                    //self.mapView.addAnnotation(point)
                    print("\(step.instructions) \(step.distance) meters")
                }
                let line = MGLPolyline(coordinates: &test, count: UInt(test.count))
                
                line.title = "Crema to Council Crest"
                self.mapView.addAnnotation(line)
                done = false
            } else {
                print("Error calculating directions: \(error)")
                done = false
            }
        }
        
        super.viewDidLoad()
        func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
            // Always try to show a callout when an annotation is tapped.
            
            return true
        }
        // Do any additional setup after loading the view.
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
