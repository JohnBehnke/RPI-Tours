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
import MapboxDirections


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
        if(directionsDidLoad) {
            self.performSegueWithIdentifier("showDirections", sender: self)
        }
        
    }
    @IBAction func stepActivate(sender: AnyObject) {
        ratingLabel.text = String(self.stepperControl.value)
    }
    @IBAction func pressedCenterMap(sender: AnyObject) {
        // Use mapView.setCenterCoordinate to recenter the map
        mapView.setCenterCoordinate(mapCenterCoordinate!, zoomLevel: mapZoom, animated: true)
    }
    
    //MARK: Global
    var selectedTour:Tour = Tour()
    //var directions: MBDirections?
    var measurementSystem:String?
    var calculatedTour:[RouteStep] = []
    var calculatedTourPoints:[CLLocationCoordinate2D] = []
    let locationManager = CLLocationManager()
    var tourLine: MGLPolyline = MGLPolyline()
    var directionsDidLoad = false
    var mapCenterCoordinate: CLLocationCoordinate2D?
    var mapZoom = 0.0
    
    
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
            measurementSystem = "Imperial"
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
        let workingWaypoints:[CLLocationCoordinate2D] = selectedTour.getWaypoints()
        
        
        let directions = Directions(accessToken: mapBoxAPIKey)
        
        var waypoints:[Waypoint] = []
        
        var shortestPoint: CLLocationCoordinate2D = workingWaypoints[0]
        let userLocation: CLLocationCoordinate2D = (self.locationManager.location?.coordinate)!
        for point in workingWaypoints {
            let user = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
            let p = CLLocation(latitude: point.latitude, longitude: point.longitude)
            let sP = CLLocation(latitude: shortestPoint.latitude, longitude: shortestPoint.longitude)
            
            if(user.distanceFromLocation(p) < user.distanceFromLocation(sP)) {
                shortestPoint = point
            }
        }
        print(shortestPoint)
        
        var shortestPointLocation = 0
        for point in workingWaypoints {
            if(point.latitude == shortestPoint.latitude && point.longitude == shortestPoint.longitude){
                break;
            }
            else {
                shortestPointLocation += 1
            }
        }
        
        waypoints.append(Waypoint(coordinate: userLocation))
        
        //waypoints.append(Waypoint(coordinate: shortestPoint))
        
        for i in 0..<(workingWaypoints.count - shortestPointLocation) {
            waypoints.append(Waypoint(coordinate: workingWaypoints[i + shortestPointLocation]))
        }
        
        for i in 0..<shortestPointLocation {
            waypoints.append(Waypoint(coordinate: workingWaypoints[i]))
        }

        
        //for point in workingWapoints{
            //waypoints.append(Waypoint(coordinate: point))
        //}
        let options = RouteOptions(waypoints: waypoints, profileIdentifier: MBDirectionsProfileIdentifierWalking)
        options.includesSteps = true
        options.routeShapeResolution = .Full
        options.allowsUTurnAtWaypoint = false

        
        _ = directions.calculateDirections(options: options) { (waypoints, routes, error) in
            guard error == nil else {
                print("Error calculating directions: \(error!)")
                return
            }
            
            
            
            if let route = routes?.first, _ = route.legs.first {
                var numSteps = 0
                for legs in route.legs{
                    numSteps += legs.steps.count
                    for step in legs.steps{
                        self.calculatedTour.append(step)
                    }
                }
                
                let distanceFormatter = NSLengthFormatter()
                var distance = ""
                
                if self.measurementSystem == "Imperial"{
                    distance = distanceFormatter.stringFromMeters(route.distance)
                     self.tourLengthLabel.text = "Distance: \(distance) (\(numSteps) route steps)"
                }
                else{
                self.tourLengthLabel.text = "Distance: \(route.distance) Meters (\(numSteps) route steps)"
                }
                
                let travelTimeFormatter = NSDateComponentsFormatter()
                travelTimeFormatter.unitsStyle = .Abbreviated
                let formattedTravelTime = travelTimeFormatter.stringFromTimeInterval(route.expectedTravelTime)
                
                self.tourTimeLabel.text = "Estimated time: \(formattedTravelTime!)"
                
                if route.coordinateCount > 0 {
                    // Convert the route’s coordinates into a polyline.
                    var routeCoordinates = route.coordinates!
                    let routeLine = MGLPolyline(coordinates: &routeCoordinates, count: route.coordinateCount)
                    
                    // Add the polyline to the map and fit the viewport to the polyline.
                    self.mapView.addAnnotation(routeLine)
                    self.tourLine = routeLine
                    self.mapView.setVisibleCoordinates(&routeCoordinates, count: route.coordinateCount, edgePadding: UIEdgeInsetsZero, animated: true)
                    
                }
                
            }
        }
        
        
        directionsDidLoad = true
        self.mapCenterCoordinate = self.mapView.centerCoordinate
        self.mapZoom = self.mapView.zoomLevel - 0.5
        self.mapView.rotateEnabled = false
        
        
        
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
            controller.tourTitle = self.selectedTour.getName()
            
        }
    }
    
    
    
    
}
