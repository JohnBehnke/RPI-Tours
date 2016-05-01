//
//  DirectionsViewController.swift
//  RPI Tours
//
//  Created by John Behnke on 4/4/16.
//  Copyright © 2016 RPI Web Tech. All rights reserved.
//

import UIKit
import Mapbox
import CoreLocation
//View Controller for the Directions Table View
class DirectionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, MGLMapViewDelegate {
    
    //MARK: Global Variables
    var measurementSystem:String?
    var tourLine: MGLPolyline = MGLPolyline()
    let locationManager = CLLocationManager()
    var tourLandmarks:[Landmark] = []
    
    
    @IBOutlet var tableView: UITableView!
    var directions:[MBRouteStep] = []
    
    //@IBOutlet var tableView: UITableView!
    @IBOutlet var mapView: MGLMapView!
    @IBAction func cancelTour(sender: AnyObject) {
        let alert = UIAlertController(title: "Are you sure you want to cancel yout tour?", message: "Canceling Tour", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
            (_)in
            self.performSegueWithIdentifier("cancelTour", sender: self)
        })
        
        alert.addAction(OKAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    //MARK: System Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationItem.rightBarButtonItem = UserTracking
        
        self.mapView.showsUserLocation = true
        
        self.mapView.userTrackingMode  = MGLUserTrackingMode.FollowWithHeading
        
        self.mapView.rotateEnabled = false
        self.mapView.delegate = self
        self.mapView.setCenterCoordinate((self.locationManager.location?.coordinate)!,zoomLevel: 17,  animated: false)
        
        self.mapView.setUserTrackingMode(MGLUserTrackingMode.FollowWithHeading, animated: true)
        
        
        
        for landmark in self.tourLandmarks{
            
            let point = MGLPointAnnotation()
            point.coordinate = CLLocationCoordinate2D(latitude: landmark.getLat(), longitude: landmark.getLong())
            point.title = landmark.getName()
            point.subtitle = landmark.getDesc()
            
            mapView.addAnnotation(point)
            
        }
        
        
        self.mapView.addAnnotation(self.tourLine)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let defaults = NSUserDefaults.standardUserDefaults()
        measurementSystem = defaults.objectForKey("system") as? String
        if measurementSystem == nil {
            measurementSystem = "Feet"
        }
        
        
        
        
    }
    
    func mapView(mapView: MGLMapView, didUpdateUserLocation userLocation: MGLUserLocation?) {
        //self.mapView.setCenterCoordinate((userLocation?.coordinate)!,zoomLevel: 17,  animated: false)
        self.mapView.userTrackingMode  = MGLUserTrackingMode.FollowWithHeading
        
        
        if directions.count == 0 {
            let alert = UIAlertController(title: "Tour Done!", message: "You finished the Tour! Congrats!", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
                (_)in
                //self.performSegueWithIdentifier("cancelTour", sender: self)
            })
            
            alert.addAction(OKAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else{
            let nextStep: MBRouteStep = directions[1]
            
            let stepLocation = CLLocation(latitude: (nextStep.maneuverLocation?.latitude)!, longitude: (nextStep.maneuverLocation?.longitude)!)
            //print(self.locationManager.location?.distanceFromLocation(stepLocation))
            if  ( (self.locationManager.location?.distanceFromLocation(stepLocation)) < 5.0) {
                directions.removeFirst()
                self.tableView.reloadData()
            }
        }
    }
    
    func mapView(mapView: MGLMapView, didChangeUserTrackingMode mode: MGLUserTrackingMode, animated: Bool) {
        self.mapView.userTrackingMode  = mode
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View Functions
    
    //Return the number of directions
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return directions.count
    }
    
    //Set up the cells
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        var distanceMeasurment:Float?
        
        
        //Switch measurement systems if necessary
        if self.measurementSystem == "Feet"{
            distanceMeasurment = metersToFeet(Float(directions[indexPath.row].distance))
        }
            
        else{
            distanceMeasurment = Float(directions[indexPath.row].distance)
        }
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("directionsCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = "\(directions[indexPath.row].instructions!)"
        cell.detailTextLabel?.text = "\(distanceMeasurment!) \(measurementSystem!)"
        
        
        return cell
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
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always try to show a callout when an annotation is tapped.
        return true
    }
    
}
