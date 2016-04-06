//
//  SelectedTourViewController.swift
//  RPI Tours
//
//  Created by John Behnke on 4/4/16.
//  Copyright © 2016 RPI Web Tech. All rights reserved.
//

import UIKit
import Mapbox
import CoreLocation

class SelectedTourViewController: UITableViewController , CLLocationManagerDelegate {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var selectedTour:Tour = Tour()
    var directions: MBDirections?
    
    var measurementSystem:String?
    
    var calculatedTour:[MBRouteStep] = []
    var calculatedTourPoints:[CLLocationCoordinate2D] = []
    let locationManager = CLLocationManager()
    
    @IBOutlet var tourLengthLabel: UILabel!
    
    @IBOutlet var mapView: MGLMapView!
    
    
    @IBOutlet var tourDescriptionLabel: UILabel!
    
    @IBOutlet var tourTimeLabel: UILabel!
    
    @IBAction func pressedStartTour(sender: AnyObject) {
        self.performSegueWithIdentifier("showDirections", sender: self)

    }
    
    
    
    override func viewDidLoad() {
        
        
        tourDescriptionLabel.text = selectedTour.getDesc()
        
        for item in selectedTour.getLandmarks() {
            let point = MGLPointAnnotation()
            point.coordinate = CLLocationCoordinate2D(latitude: item.getLat(), longitude: item.getLong())
            point.title = item.getName()
            
            mapView.addAnnotation(point)
        }
        
        measurementSystem = defaults.objectForKey("system") as? String
        if measurementSystem == nil {
            measurementSystem = "Feet"
        }
        
        
        calculateDirections()
        
        super.viewDidLoad()
        
        
        
        
    }
    
    
    
        
    
    func calculateDirections() {
        var workingWapoints:[CLLocationCoordinate2D] = selectedTour.getWaypoints()
        let request = MBDirectionsRequest(sourceCoordinate: workingWapoints.removeFirst() , waypointCoordinates:workingWapoints, destinationCoordinate: workingWapoints.removeLast())
        
        request.transportType = MBDirectionsRequest.MBDirectionsTransportType.Walking
        directions = MBDirections(request: request, accessToken: mapBoxAPIKey)
        directions!.calculateDirectionsWithCompletionHandler { (response, error) in
            if let route = response?.routes.first {
                
                
                
                var distanceMeasurment:Float?
                
                if self.measurementSystem == "Feet"{
                    distanceMeasurment = metersToFeet(Float(route.distance))
                }
                
                else{
                    distanceMeasurment = Float(route.distance)
                }
                self.tourLengthLabel.text = "Distance: \(distanceMeasurment!) \(self.measurementSystem!) (\(route.steps.count) route steps)"
                
                self.tourTimeLabel .text = "\(route.expectedTravelTime / 60) minutes"
                for step in route.steps {
                    //let point = MGLPointAnnotation()
                    self.calculatedTour.append(step)
                    self.calculatedTourPoints.append(step.maneuverLocation!)
                    //self.mapView.addAnnotation(point)
                    //print("\(step.instructions) \(step.distance) meters")
                }
                let line = MGLPolyline(coordinates: &self.calculatedTourPoints, count: UInt(self.calculatedTour.count))
                
                self.mapView.addAnnotation(line)
                
                
                
            } else {
                print("Error calculating directions: \(error)")
                
                
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }
    
    
    
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always try to show a callout when an annotation is tapped.
        
        return true
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
        if annotation is MGLPolyline {
            
            
            return UIColor(red: 59/255, green:178/255, blue:208/255, alpha:1)
            
        }
        else
        {
            return UIColor.redColor()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDirections" {
            
            let controller = segue.destinationViewController  as! DirectionsViewController //Create the detailVC
            
           controller.directions = self.calculatedTour
            
        }
    }
    
    
    
    
}
