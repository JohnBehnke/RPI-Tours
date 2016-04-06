//
//  DirectionsViewController.swift
//  RPI Tours
//
//  Created by John Behnke on 4/4/16.
//  Copyright © 2016 RPI Web Tech. All rights reserved.
//

import UIKit


//View Controller for the Directions Table View
class DirectionsViewController: UITableViewController {
    
    
    var measurementSystem:String?
    
    var directions:[MBRouteStep] = []

    override func viewDidLoad() {
        
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

    // MARK: - Table view data source

   
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return directions.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        var distanceMeasurment:Float?
        
        if self.measurementSystem == "Feet"{
            distanceMeasurment = metersToFeet(Float(directions[indexPath.row].distance))
        }
            
        else{
            distanceMeasurment = Float(directions[indexPath.row].distance)
        }


        let cell = tableView.dequeueReusableCellWithIdentifier("directionCell", forIndexPath: indexPath)

        cell.textLabel?.text = "\(directions[indexPath.row].instructions)  \(distanceMeasurment!) \(measurementSystem!)"

        return cell
    }
    
    
    

}
