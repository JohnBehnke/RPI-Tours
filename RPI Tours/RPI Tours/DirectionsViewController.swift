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

class DirectionsViewController: UIViewController, CLLocationManagerDelegate, MGLMapViewDelegate {
    
    //MARK: Global Variables
    var measurementSystem:String?
    var tourLine: MGLPolyline = MGLPolyline()
    let locationManager = CLLocationManager()
    var tourLandmarks:[Landmark] = []
    var tourTitle:String = ""
    var directions:[RouteStep] = []
    var tappedLandmarkName: String = ""
    var landmarkInformation: [Landmark] = []
    
    @IBOutlet weak var directionsView: UIView!
    
    @IBOutlet weak var Directions_Label: UILabel!
    
    @IBOutlet weak var Amount_Label: UILabel!
    
    @IBOutlet weak var Image_Label: UIImageView!
    
    @IBOutlet weak var Button_Label: UIButton!
    @IBOutlet weak var End_View: UIView!
    
    //@IBOutlet var tableView: UITableView!
    @IBOutlet var mapView: MGLMapView!
    @IBAction func pressedCancelTour(sender: AnyObject) {
        let alert = UIAlertController(title: "Are you sure you want to cancel your tour?", message: "Canceling Tour", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
            (_)in
            self.performSegueWithIdentifier("cancelTour", sender: self)
        })
        
        let CancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            (action:UIAlertAction) in print("pressed no")
        }
        
        alert.addAction(OKAction)
        alert.addAction(CancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    //MARK: System Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden =  true
        
        //Status bar style and visibility
        UIApplication.sharedApplication().statusBarHidden = false
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        //Change status bar color
        let statusBar: UIView = UIApplication.sharedApplication().valueForKey("statusBar") as! UIView
        if statusBar.respondsToSelector(Selector("setBackgroundColor:")) {
            statusBar.backgroundColor = UIColor(red:0.87, green:0.28, blue:0.32, alpha:1.0)
            
        }
        
        self.navigationItem.title = self.tourTitle
        
        //self.navigationItem.rightBarButtonItem = UserTracking
        
        self.mapView.showsUserLocation = true
        
        self.mapView.compassView.hidden = true
        
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
        
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        measurementSystem = defaults.objectForKey("system") as? String
        if measurementSystem == nil {
            measurementSystem = "Imperial"
        }
        
        displayInstruction()
        
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
//            displayInstruction()
            generateNextDirection()
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
    
    func displayInstruction(){
        Directions_Label.text = directions[0].instructions
        var distanceMeasurment:Float
        if self.measurementSystem == "Imperial"{
            distanceMeasurment = metersToFeet(Float(directions[0].distance))
        }
            
        else{
            distanceMeasurment = Float(directions[0].distance)
        }
        
        Amount_Label.text = "\(distanceMeasurment)"
        print(directions[0].maneuverDirection)
        
        if directions[0].maneuverDirection == ManeuverDirection.StraightAhead{
            Image_Label.image = UIImage(named: "straight")
        }
        if directions[0].maneuverDirection == ManeuverDirection.SharpLeft{
            Image_Label.image = UIImage(named: "hLeft")
        }
        if directions[0].maneuverDirection == ManeuverDirection.SharpRight{
            Image_Label.image = UIImage(named: "hRight")
        }
        if directions[0].maneuverDirection == ManeuverDirection.SlightLeft{
            Image_Label.image = UIImage(named: "sLeft")
        }
        if directions[0].maneuverDirection == ManeuverDirection.SlightRight{
            Image_Label.image = UIImage(named: "sRight")
        }
        if directions[0].maneuverDirection == ManeuverDirection.Left{
            Image_Label.image = UIImage(named: "Left")
        }
        if directions[0].maneuverDirection == ManeuverDirection.Right{
            Image_Label.image = UIImage(named: "Right")
        }
        if directions[0].maneuverDirection == ManeuverDirection.UTurn{
            Image_Label.image = UIImage(named: "uTurn")
        }
        
        
        directions.removeFirst()
    }
    
    func generateNextDirection() {
        let nextStep: RouteStep = directions[1]
        
        let stepLocation = CLLocation(latitude: (nextStep.maneuverLocation.latitude), longitude: (nextStep.maneuverLocation.longitude))
        //print(self.locationManager.location?.distanceFromLocation(stepLocation))
        if  ( (self.locationManager.location?.distanceFromLocation(stepLocation)) < 3) {
            displayInstruction()
        }
    }
    
}
