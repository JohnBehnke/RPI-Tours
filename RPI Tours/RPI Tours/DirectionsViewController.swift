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

    // MARK: Global Variables
    var measurementSystem: String?
    var tourLine: MGLPolyline = MGLPolyline()
    let locationManager: CLLocationManager! = CLLocationManager()
    var tourLandmarks: [Landmark] = []
    var tourTitle: String = ""
    var directions: [RouteStep] = []
    var tappedLandmarkName: String = ""
    var landmarkInformation: [Landmark] = []

    @IBOutlet weak var directionsView: UIView!

    @IBOutlet weak var directionsLabel: UILabel!

    @IBOutlet weak var amountLabel: UILabel!

    @IBOutlet weak var imageLabel: UIImageView!

    @IBOutlet weak var buttonLabel: UIButton!
    @IBOutlet weak var endView: UIView!

    //@IBOutlet var tableView: UITableView!
    @IBOutlet var mapView: MGLMapView!
    @IBAction func pressedCancelTour(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Are you sure you want to cancel your tour?",
                                      message: "Canceling Tour",
                                      preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(_)in
            self.performSegue(withIdentifier: "cancelTour", sender: self)
        })

        let CancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {(_) in
            print("pressed no")
        }

        alert.addAction(OKAction)
        alert.addAction(CancelAction)
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func getInfo(_ sender: AnyObject) {
        var shortestPoint: CLLocationCoordinate2D = (self.tourLandmarks.first?.point)!
        var name: String = ""
        let userLocation: CLLocationCoordinate2D = (self.locationManager.location?.coordinate)!

        for point in self.tourLandmarks {

            let user = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
            let p = CLLocation(latitude: point.point.latitude, longitude: point.point.longitude)
            let sP = CLLocation(latitude: shortestPoint.latitude, longitude: shortestPoint.longitude)

            if user.distance(from: p) < user.distance(from: sP) {
                shortestPoint = point.point
                name = point.name
            }
        }

        tappedLandmarkName = name
        self.performSegue(withIdentifier: "showInfo", sender: self)
    }

    // MARK: System Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden =  true

        //Status bar style and visibility
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent

        //Change status bar color
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = UIColor(red:0.87, green:0.28, blue:0.32, alpha:1.0)

        }

        self.navigationItem.title = self.tourTitle

        self.mapView.showsUserLocation = true

        self.mapView.compassView.isHidden = true

        self.mapView.userTrackingMode  = MGLUserTrackingMode.followWithHeading

        self.mapView.isRotateEnabled = false
        self.mapView.delegate = self
        self.mapView.setCenter((self.locationManager.location?.coordinate)!, zoomLevel: 17, animated: false)

        self.mapView.setUserTrackingMode(MGLUserTrackingMode.followWithHeading, animated: true)

        for landmark in self.tourLandmarks {

            let point = MGLPointAnnotation()
            point.coordinate = landmark.point
            point.title = landmark.name
            mapView.addAnnotation(point)
        }

        self.mapView.addAnnotation(self.tourLine)

        let defaults = UserDefaults.standard
        measurementSystem = defaults.object(forKey: "system") as? String
        if measurementSystem == nil {
            measurementSystem = "Imperial"
        }

        displayInstruction()

    }

    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
        self.mapView.userTrackingMode  = MGLUserTrackingMode.followWithHeading

        if directions.count == 0 {
            let alert = UIAlertController(title: "Tour Done!",
                                          message: "You finished the Tour! Congrats!",
                                          preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(_)in
                self.performSegue(withIdentifier: "cancelTour", sender: self)
            })

            alert.addAction(OKAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            generateNextDirection()
        }
    }

    func mapView(_ mapView: MGLMapView, didChange mode: MGLUserTrackingMode, animated: Bool) {
        self.mapView.userTrackingMode = mode
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        // Give our polyline a unique color by checking for its `title` property
        if annotation is MGLPolyline {

            return UIColor(red: 59/255, green:178/255, blue:208/255, alpha:1)

        } else {
            return UIColor.red
        }
    }

    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always try to show a callout when an annotation is tapped.

        return annotation.title!! != "You Are Here"
    }

    func mapView(_ mapView: MGLMapView, rightCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        return UIButton(type: .detailDisclosure)
    }

    func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        // Hide callout view
        mapView.deselectAnnotation(annotation, animated: true)

        tappedLandmarkName = annotation.title!!

        self.performSegue(withIdentifier: "showInfo", sender: self)
    }

    // MARK: Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showInfo" {
            let controller = segue.destination as! InfoViewController

            controller.landmarkName = self.tappedLandmarkName
            controller.landmarkInformation = self.landmarkInformation
            controller.cameFromMap = false

            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }

    func displayInstruction() {
        directionsLabel.text = directions[0].instructions
        var distanceMeasurment: Float
        if self.measurementSystem == "Imperial"{
            distanceMeasurment = metersToFeet(Float(directions[0].distance))
            amountLabel.text = "\(Int(distanceMeasurment)) feet"
        } else {
            distanceMeasurment = Float(directions[0].distance)
            amountLabel.text = "\(Int(distanceMeasurment)) meters"
        }

//        print(directions[0].maneuverDirection!)

        if directions[0].maneuverType == ManeuverType.arrive {
            imageLabel.image = UIImage(named: "arrive")
            self.buttonLabel.isHidden  = false
        } else {
            self.buttonLabel.isHidden = true
        }

        if directions[0].maneuverType == ManeuverType.depart {
            imageLabel.image = UIImage(named: "depart")
        }

        if directions[0].maneuverDirection == ManeuverDirection.straightAhead {
            imageLabel.image = UIImage(named: "straight")
        }
        if directions[0].maneuverDirection == ManeuverDirection.sharpLeft {
            imageLabel.image = UIImage(named: "hLeft")
        }
        if directions[0].maneuverDirection == ManeuverDirection.sharpRight {
            imageLabel.image = UIImage(named: "hRight")
        }
        if directions[0].maneuverDirection == ManeuverDirection.slightLeft {
            imageLabel.image = UIImage(named: "sLeft")
        }
        if directions[0].maneuverDirection == ManeuverDirection.slightRight {
            imageLabel.image = UIImage(named: "sRight")
        }
        if directions[0].maneuverDirection == ManeuverDirection.left {
            imageLabel.image = UIImage(named: "Left")
        }
        if directions[0].maneuverDirection == ManeuverDirection.right {
            imageLabel.image = UIImage(named: "Right")
        }
        if directions[0].maneuverDirection == ManeuverDirection.uTurn {
            imageLabel.image = UIImage(named: "uTurn")
        }

        directions.removeFirst()
    }

    func generateNextDirection() {
        let nextStep: RouteStep = directions[1]

        let stepLocation = CLLocation(latitude: (nextStep.maneuverLocation.latitude),
                                      longitude: (nextStep.maneuverLocation.longitude))

        if  (self.locationManager.location?.distance(from: stepLocation).significandBitPattern)! < 3 {
            displayInstruction()
        }
    }

}
