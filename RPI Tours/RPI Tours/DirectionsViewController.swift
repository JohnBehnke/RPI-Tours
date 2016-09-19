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
import MapboxDirections
//View Controller for the Directions Table View

class DirectionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, MGLMapViewDelegate {
    
    //MARK: Global Variables
    var measurementSystem:String?
    var tourLine: MGLPolyline = MGLPolyline()
    let locationManager = CLLocationManager()
    var tourLandmarks:[Landmark] = []
    var tourTitle:String = ""
    var directions:[RouteStep] = []
    var tappedLandmarkName: String = ""
    var landmarkInformation: [Landmark] = []
    
    
    
    @IBOutlet var tableView: UITableView!
    
    
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
        
        self.navigationItem.title = self.tourTitle
        
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
            //point.subtitle = landmark.getDesc()
            
            mapView.addAnnotation(point)
            
        }
        
        
        self.mapView.addAnnotation(self.tourLine)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let defaults = NSUserDefaults.standardUserDefaults()
        measurementSystem = defaults.objectForKey("system") as? String
        if measurementSystem == nil {
            measurementSystem = "Imperial"
        }
        
//        for directionManuever in directions {
//            print(directionManuever.maneuverDirection)
//        }
//
        
    }
    
    func mapView(mapView: MGLMapView, didUpdateUserLocation userLocation: MGLUserLocation?) {
        //self.mapView.setCenterCoordinate((userLocation?.coordinate)!,zoomLevel: 17,  animated: false)
        self.mapView.userTrackingMode  = MGLUserTrackingMode.FollowWithHeading
        
        
        if directions.count == 0 {
            let alert = UIAlertController(title: "Tour Done!", message: "You finished the Tour! Congrats!", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
                (_)in
                self.performSegueWithIdentifier("cancelTour", sender: self)
            })
            
            alert.addAction(OKAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else{
            let nextStep: RouteStep = directions[1]
            
            let stepLocation = CLLocation(latitude: (nextStep.maneuverLocation.latitude), longitude: (nextStep.maneuverLocation.longitude))
            //print(self.locationManager.location?.distanceFromLocation(stepLocation))
            if  ( (self.locationManager.location?.distanceFromLocation(stepLocation)) < 3) {
                let index = NSIndexPath(forRow: 0, inSection: 0)
                self.directions.removeAtIndex(index.row)
                //self.tableView.deleteRowsAtIndexPaths([index], withRowAnimation: .Right)
                self.tableView.reloadData()
            }
            
        }
    }
    
    func mapView(mapView: MGLMapView, didChangeUserTrackingMode mode: MGLUserTrackingMode, animated: Bool) {
        self.mapView.userTrackingMode  = mode
    }
    
    func mapView(mapView: MGLMapView, tapOnCalloutForAnnotation annotation: MGLAnnotation) {
        mapView.deselectAnnotation(annotation, animated: true)
        tappedLandmarkName = annotation.title!!
        self.performSegueWithIdentifier("showInfo", sender: self)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View Functions
    
    //Return the number of directions
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return directions.count
        return 5
    }
    
    //Set up the cells
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        var distanceMeasurment:Float?
        
        
        //Switch measurement systems if necessary
        if self.measurementSystem == "Imperial"{
            distanceMeasurment = metersToFeet(Float(directions[indexPath.row].distance))
        }
            
        else{
            distanceMeasurment = Float(directions[indexPath.row].distance)
        }
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("DirectionTableViewCell", forIndexPath: indexPath) as? DirectionTableViewCell
//        
        
        cell?.directionLabel.text = "\(directions[indexPath.row].instructions)"
        cell?.distanceLabel.text = "\(distanceMeasurment!) \(measurementSystem == "Imperial" ? "feet" :  "meters")"
        //Get ready for grossness oh god forgive me for my sins
        
        if directions[indexPath.row].maneuverDirection == ManeuverDirection.StraightAhead{
            cell?.directionImage.image = UIImage(named: "straight")
        }
        if directions[indexPath.row].maneuverDirection == ManeuverDirection.SharpLeft{
            cell?.directionImage.image = UIImage(named: "hLeft")
        }
        if directions[indexPath.row].maneuverDirection == ManeuverDirection.SharpRight{
            cell?.directionImage.image = UIImage(named: "hRight")
        }
        if directions[indexPath.row].maneuverDirection == ManeuverDirection.SlightLeft{
            cell?.directionImage.image = UIImage(named: "sLeft")
        }
        if directions[indexPath.row].maneuverDirection == ManeuverDirection.SlightRight{
            cell?.directionImage.image = UIImage(named: "sRight")
        }
        if directions[indexPath.row].maneuverDirection == ManeuverDirection.Left{
            cell?.directionImage.image = UIImage(named: "Left")
        }
        if directions[indexPath.row].maneuverDirection == ManeuverDirection.Right{
            cell?.directionImage.image = UIImage(named: "Right")
        }
        if directions[indexPath.row].maneuverDirection == ManeuverDirection.UTurn{
            cell?.directionImage.image = UIImage(named: "uTurn")
        }
        
        if directions[indexPath.row].maneuverType == ManeuverType.Arrive {
            cell?.accessoryType = .DisclosureIndicator
            cell?.directionImage.image = nil
        }
        
        
        //cell?.directionImage.contentMode = .ScaleToFill

        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if directions[indexPath.row].maneuverType == ManeuverType.Arrive {
            
            var shortestPoint: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: self.tourLandmarks[0].getLat(), longitude: self.tourLandmarks[0].getLong())
            var name: String = ""
            let userLocation: CLLocationCoordinate2D = (self.locationManager.location?.coordinate)!
            
            for point in self.tourLandmarks {
                
                let user = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
                let p = CLLocation(latitude: point.getLat(), longitude: point.getLong())
                let sP = CLLocation(latitude: shortestPoint.latitude, longitude: shortestPoint.longitude)
                
                if(user.distanceFromLocation(p) < user.distanceFromLocation(sP)) {
                    shortestPoint = CLLocationCoordinate2D(latitude: point.getLat(), longitude: point.getLong())
                    name = point.getName()
                }
            }
            
            tappedLandmarkName = name
            self.performSegueWithIdentifier("showInfo", sender: self)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
    
    func mapView(mapView: MGLMapView, rightCalloutAccessoryViewForAnnotation annotation: MGLAnnotation) -> UIView? {
        return UIButton(type: .DetailDisclosure)
    }
    
    func mapView(mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        // Hide callout view
        mapView.deselectAnnotation(annotation, animated: true)
        
        tappedLandmarkName = annotation.title!!
        self.performSegueWithIdentifier("showInfo", sender: self)
    }
    
    //MARK: Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showInfo" {
            let controller = segue.destinationViewController as! InfoViewController
            
            controller.landmarkName = self.tappedLandmarkName
            controller.landmarkInformation = self.landmarkInformation
            
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }
    
}
