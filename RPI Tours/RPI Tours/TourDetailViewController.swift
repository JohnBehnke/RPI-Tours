//
//  TourDetailViewController.swift
//  RPI Tours
//
//  Created by John Behnke on 3/26/16.
//  Copyright © 2016 RPI Web Tech. All rights reserved.
//

import UIKit
import Mapbox
import CoreLocation

class TourDetailViewController: UIViewController , CLLocationManagerDelegate  {

    @IBOutlet  var mapView: MGLMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
            // Always try to show a callout when an annotation is tapped.
            return true
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
