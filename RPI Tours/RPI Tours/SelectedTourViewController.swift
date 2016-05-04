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
    
    //MARK: IBOUTLETS
    @IBOutlet var tourLengthLabel: UILabel!
    @IBOutlet var mapView: MGLMapView!
    @IBOutlet var tourDescriptionLabel: UILabel!
    @IBOutlet var stepperControl: UIStepper!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var tourTimeLabel: UILabel!

    //MARK: IBAction
    @IBAction func pressedStartTour(sender: AnyObject) {
        self.performSegueWithIdentifier("showDirections", sender: self)
        
    }
    @IBAction func stepActivate(sender: AnyObject) {
        ratingLabel.text = String(self.stepperControl.value)
    }
    
    //MARK: Global
    var selectedTour:Tour = Tour()
    var directions: MBDirections?
    var measurementSystem:String?
    var calculatedTour:[MBRouteStep] = []
    var calculatedTourPoints:[CLLocationCoordinate2D] = []
    let locationManager = CLLocationManager()
    var tourLine: MGLPolyline = MGLPolyline()
        
    
    //MARK: System Functions
    override func viewDidLoad() {
        
       

        //Set the desctiption label for the tour
        tourDescriptionLabel.text = selectedTour.getDesc()
        
        //For
        for item in selectedTour.getLandmarks() {
            let point = MGLPointAnnotation()
            point.coordinate = CLLocationCoordinate2D(latitude: item.getLat(), longitude: item.getLong())
            point.title = item.getName()
            point.subtitle = item.getDesc()
            
            mapView.addAnnotation(point)
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        measurementSystem = defaults.objectForKey("system") as? String
        if measurementSystem == nil {
            measurementSystem = "Feet"
        }
        
        
        calculateDirections()
        
        
         super.viewDidLoad()
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK: Helper Functions
    
    func calculateDirections() {
        
        //Get the waypoints for the tour
        var workingWapoints:[CLLocationCoordinate2D] = selectedTour.getWaypoints()
        
        //Make a request for directions
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
                self.tourLengthLabel.text = "Distance: \(round(distanceMeasurment!)) \(self.measurementSystem!) (\(route.steps.count) route steps)"
                
                var times  = secondsToHoursMinutesSeconds(route.expectedTravelTime as Double)
                
                self.tourTimeLabel .text = "\(times.0) hours, \(times.1) miniutes"
                for step in route.steps {
                    //let point = MGLPointAnnotation()
                    self.calculatedTour.append(step)
                    self.calculatedTourPoints.append(step.maneuverLocation!)
                    //self.mapView.addAnnotation(point)
                    //print("\(step.instructions) \(step.distance) meters")
                }
                self.tourLine = MGLPolyline(coordinates: &self.calculatedTourPoints, count: UInt(self.calculatedTour.count))
                
                self.mapView.addAnnotation(self.tourLine)
                
                
            //This needs to go to an actual kill error
            } else {
                print("Error calculating directions: \(error)")
                
                
            }
        }
        
//        let mapBox = CLLocationCoordinate2D(latitude: 38.9131752, longitude: -77.0324047)
//        let whiteHouse = CLLocationCoordinate2D(latitude: 38.8977, longitude: -77.0365)
//        let request = MBDirectionsRequest(sourceCoordinate: mapBox, destinationCoordinate: whiteHouse)
//        
//        // Use the older v4 endpoint for now, while v5 is in development.
//        request.version = .Four
//        
//        let directions = MBDirections(request: request, accessToken: MapboxAccessToken)
//        directions.calculateDirectionsWithCompletionHandler { (response, error) in
//            if let route = response?.routes.first {
//                print("Enjoy a trip down \(route.legs.first!.name)!")
//            }
//        }
        
    }
    
    
    // MARK: Table View Functions
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
        //Number of sections in the UI
    }
    
    
    //MARK: Mapbox Helper Functions
    
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
    
    
    //MARK: Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDirections" {
            
            let controller = segue.destinationViewController  as! DirectionsViewController //Create the detailVC
            
           controller.directions = self.calculatedTour
           controller.tourLine = self.tourLine
            controller.tourLandmarks = self.selectedTour.getLandmarks()
            
        }
    }
    
    
    
    
}
