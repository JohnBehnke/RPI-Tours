//
//  GeneralMapViewController.swift
//  RPI Tours
//
//  Created by John Behnke on 3/16/16.
//  Copyright © 2016 RPI Web Tech. All rights reserved.
//

import UIKit
import Mapbox
import CoreLocation


class GeneralMapViewController: UIViewController, CLLocationManagerDelegate {
    
    
    //MARK: IBOutlets
    @IBOutlet var mapView: MGLMapView!
    
    //MARK: Global Variables
    var directions: MBDirections?
    
    //MARK: System Function
    override func viewDidLoad() {
        
        let locationManager = CLLocationManager()
        // Ask for Authorisation from the User.
        locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        
        
        if CLLocationManager.locationServicesEnabled() {

            let campusBuildings = buildCSV()

            
            super.viewDidLoad()
            
            
            
            for item in campusBuildings {
                let point = MGLPointAnnotation()
                point.coordinate = CLLocationCoordinate2D(latitude: item.buildingLat, longitude: item.buildingLong)
                point.title = item.buildingName
                
                mapView.addAnnotation(point)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Mapbox Helper Functions
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always try to show a callout when an annotation is tapped.
        return true
    }
    
    
    
    
}
