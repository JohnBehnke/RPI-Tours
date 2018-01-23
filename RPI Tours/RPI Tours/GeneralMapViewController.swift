//
//  GeneralMapViewController.swift
//  RPI Tours
//
//  Created by John Behnke on 3/16/16.
//  Copyright © 2016 RPI Web Tech. All rights reserved.
//

import CoreLocation
import MapboxDirections
import Mapbox
import UIKit

class GeneralMapViewController: UIViewController, CLLocationManagerDelegate, MGLMapViewDelegate {

    // MARK: IBOutlets
    @IBOutlet var mapView: MGLMapView!

    // MARK: Class Variables
    var tappedLandmarkName: String = ""
    var landmarkInformation: [Landmark] = []
    let locationManager: CLLocationManager! = CLLocationManager()

    // MARK: System Function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestAlwaysAuthorization()

        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {

            let campusBuildings = buildCSV()

            mapView.delegate = self
            
            for item in campusBuildings {
                let point = MGLPointAnnotation()
                point.coordinate = CLLocationCoordinate2D(latitude: item.buildingLat, longitude: item.buildingLong)
                point.title = item.buildingName

                mapView.addAnnotation(point)
            }
        }

        self.landmarkInformation = jsonParserLand()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Mapbox Helper Functions

    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }

    func mapView(_ mapView: MGLMapView, rightCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        return UIButton(type: .detailDisclosure)
    }

    func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        mapView.deselectAnnotation(annotation, animated: true)
        tappedLandmarkName = annotation.title!!
        self.performSegue(withIdentifier: "showInfo", sender: self)
    }

    // MARK: Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier{
            switch identifier {
            case "showInfo":
                let controller = segue.destination as! InfoViewController
                
                controller.landmarkName = self.tappedLandmarkName
                controller.landmarkInformation = self.landmarkInformation
                controller.cameFromMap = true
                
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true //Make a back button
            default: return 
            }
        }
    }
}
