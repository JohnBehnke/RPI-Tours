//
//  DirectionsViewController.swift
//  RPI Tours
//
//  Created by John Behnke on 4/4/16.
//  Copyright © 2016 RPI Web Tech. All rights reserved.
//

import UIKit
import Mapbox

//View Controller for the Directions Table View
class DirectionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: Global Variables
    var measurementSystem:String?
    var tourLine: MGLPolyline = MGLPolyline()
    
    @IBOutlet var tableView: UITableView!
    var directions:[MBRouteStep] = []

    //@IBOutlet var tableView: UITableView!
    @IBOutlet var mapView: MGLMapView!
    //MARK: IBActions
//    @IBAction func cancelTour(sender: AnyObject) {
//        
//        
//        
//        let alert = UIAlertController(title: "Are you sure you want to cancel yout tour?", message: "Canceling Tour", preferredStyle: .Alert)
//        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
//            (_)in
//            self.performSegueWithIdentifier("cancelTour", sender: self)
//        })
//        
//        alert.addAction(OKAction)
//        self.presentViewController(alert, animated: true, completion: nil)
//    }
    
    //MARK: System Functions
    override func viewDidLoad() {
        
        self.mapView.addAnnotation(self.tourLine)
        tableView.delegate = self
        tableView.dataSource = self
        
        let defaults = NSUserDefaults.standardUserDefaults()
        measurementSystem = defaults.objectForKey("system") as? String
        if measurementSystem == nil {
            measurementSystem = "Feet"
        }

        super.viewDidLoad()

        
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

        cell.textLabel?.text = "\(directions[indexPath.row].instructions)  \(distanceMeasurment!) \(measurementSystem!)"

        return cell
    }
    
}
