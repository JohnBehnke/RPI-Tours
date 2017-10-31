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

class SelectedTourViewController: UITableViewController, CLLocationManagerDelegate, MGLMapViewDelegate {

    // MARK: IBOUTLETS
    @IBOutlet var tourLengthLabel: UILabel!
    @IBOutlet var mapView: MGLMapView!
    @IBOutlet var tourDescriptionLabel: UILabel!
    @IBOutlet var stepperControl: UIStepper!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var tourTimeLabel: UILabel!

    // MARK: IBAction
    @IBAction func pressedStartTour(_ sender: AnyObject) {
        if directionsDidLoad {
            self.performSegue(withIdentifier: "showDirections", sender: self)
        }

    }
    @IBAction func stepActivate(_ sender: AnyObject) {
        ratingLabel.text = String(self.stepperControl.value)
    }
    @IBAction func pressedCenterMap(_ sender: AnyObject) {
        // Use mapView.setCenterCoordinate to recenter the map
        mapView.setCenter((self.locationManager.location?.coordinate)!, zoomLevel: 15, animated: true)
    }

    // MARK: Global
    var selectedTour: Tour = Tour()
    //var directions: MBDirections?
    var measurementSystem: String?
    var calculatedTour: [RouteStep] = []
    var calculatedTourPoints: [CLLocationCoordinate2D] = []
    let locationManager: CLLocationManager! = CLLocationManager()
    var tourLine: MGLPolyline = MGLPolyline()
    var directionsDidLoad = false
    var mapCenterCoordinate: CLLocationCoordinate2D?
    var mapZoom = 0.0
    var tappedLandmarkName: String = ""
    var landmarkInformation: [Landmark] = []

    // MARK: System Functions
    override func viewDidLoad() {

        //Set the description label for the tour
        tourDescriptionLabel.text = selectedTour.desc
        
        mapView.delegate = self

        
        
        for item in selectedTour.landmarks {
            let point = MGLPointAnnotation()
            point.coordinate = item.point
            
            point.title = item.name
            mapView.addAnnotation(point)
        }

        let defaults = UserDefaults.standard
        measurementSystem = defaults.object(forKey: "system") as? String
        if measurementSystem == nil {
            measurementSystem = "Imperial"
        }

        //Call the JSON parser for Landmark Info
        self.landmarkInformation = selectedTour.landmarks
        
        calculateDirections()

        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Helper Functions

    func calculateDirections() {

        //Get the waypoints for the tour
        let workingWaypoints: [CLLocationCoordinate2D] = selectedTour.waypoints
        

        let directions = Directions(accessToken: mapBoxAPIKey)

        var waypoints: [Waypoint] = []

        var shortestPoint: CLLocationCoordinate2D = workingWaypoints[0]

        if self.locationManager.location != nil {
            let userLocation: CLLocationCoordinate2D = (self.locationManager.location?.coordinate)!

            for point in workingWaypoints {
                let user = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
                let p = CLLocation(latitude: point.latitude, longitude: point.longitude)
                let sP = CLLocation(latitude: shortestPoint.latitude, longitude: shortestPoint.longitude)

                if user.distance(from: p) < user.distance(from: sP) {
                    shortestPoint = point
                }
            }

            waypoints.append(Waypoint(coordinate: userLocation))
        }

        var shortestPointLocation = 0
        for point in workingWaypoints {
            if point.latitude == shortestPoint.latitude && point.longitude == shortestPoint.longitude {
                break
            } else {
                shortestPointLocation += 1
            }
        }

        for i in 0..<(workingWaypoints.count - shortestPointLocation) {
            waypoints.append(Waypoint(coordinate: workingWaypoints[i + shortestPointLocation]))
        }

        for i in 0..<shortestPointLocation {
            waypoints.append(Waypoint(coordinate: workingWaypoints[i]))
        }

        let options = RouteOptions(waypoints: waypoints, profileIdentifier: MBDirectionsProfileIdentifier.walking)
        options.includesSteps = true
        options.routeShapeResolution = .full
        options.allowsUTurnAtWaypoint = false

        _ = directions.calculate(options) { (_, routes, error) in
            guard error == nil else {
                return
            }

            if let route = routes?.first, let _ = route.legs.first {

                var numSteps = 0
                for legs in route.legs {
                    numSteps += legs.steps.count
                    for step in legs.steps {
                        self.calculatedTour.append(step)
                    }
                }

                let distanceFormatter = LengthFormatter()
                var distance = ""

                if self.measurementSystem == "Imperial"{
                    distance = distanceFormatter.string(fromMeters: route.distance)
                     self.tourLengthLabel.text = "Distance: \(distance) (\(numSteps) route steps)"
                } else {
                self.tourLengthLabel.text = "Distance: \(route.distance) Meters (\(numSteps) route steps)"
                }

                let travelTimeFormatter = DateComponentsFormatter()
                travelTimeFormatter.unitsStyle = .abbreviated
                let formattedTravelTime = travelTimeFormatter.string(from: route.expectedTravelTime)

                self.tourTimeLabel.text = "Estimated time: \(formattedTravelTime!)"

                if route.coordinateCount > 0 {
                    // Convert the route’s coordinates into a polyline.
                    var routeCoordinates = route.coordinates!
                    let routeLine = MGLPolyline(coordinates: &routeCoordinates, count: route.coordinateCount)

                    // Add the polyline to the map and fit the viewport to the polyline.
                    self.mapView.addAnnotation(routeLine)
                    self.tourLine = routeLine
                }

            }
        }

        directionsDidLoad = true
        self.mapCenterCoordinate = self.mapView.centerCoordinate
        self.mapZoom = self.mapView.zoomLevel - 0.5
        self.mapView.isRotateEnabled = false

    }

    // MARK: Table View Functions
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
        //Number of sections in the UI
    }

    // MARK: Mapbox Helper Functions

    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always try to show a callout when an annotation is tapped.

        return true
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

    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        tappedLandmarkName = annotation.title!!
        mapView.deselectAnnotation(annotation, animated: true)
        self.performSegue(withIdentifier: "showInfo", sender: self)
    }

    func mapView(_ mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat {
        // Set the alpha for all shape annotations to 1 (full opacity)
        return 1
    }

    func mapView(_ mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
        // Set the line width for polyline annotations
        return 4.0
    }

    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        // Give our polyline a unique color by checking for its `title` property
        if annotation is MGLPolyline {

            return Constants.Colors.Mapbox.pathColor
            

        } else {
            return UIColor.red
        }
    }

    // MARK: Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDirections" {

            let controller = segue.destination  as! DirectionsViewController //Create the detailVC

            controller.directions = self.calculatedTour
            controller.tourLine = self.tourLine
            controller.tourLandmarks = self.selectedTour.landmarks
            controller.tourTitle = self.selectedTour.name
            controller.landmarkInformation = self.landmarkInformation

        }

        if segue.identifier == "showInfo" {
            let controller = segue.destination as! InfoViewController

            controller.landmarkName = self.tappedLandmarkName
            controller.landmarkInformation = self.landmarkInformation
            controller.cameFromMap = false

            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true //Make a back button
        }
    }

}
