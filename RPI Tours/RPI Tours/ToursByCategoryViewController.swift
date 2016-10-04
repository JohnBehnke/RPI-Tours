//
//  ToursByCategoryViewController
//  RPI Tours
//
//  Created by John Behnke on 2/6/16.
//  Copyright © 2016 RPI Web Tech. All rights reserved.
//

import UIKit
import ReachabilitySwift
import CoreLocation

class ToursByCategoryViewController: UITableViewController{
    
    //MARK: IBAction
    //Rewind point for going back to this VC
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
        self.navigationController?.navigationBarHidden = false
        
        //sets status bar and navigation bar to the same color
        let statusBar: UIView = UIApplication.sharedApplication().valueForKey("statusBar") as! UIView
        statusBar.backgroundColor = self.navigationController?.navigationBar.backgroundColor
    }
    
    //MARK: Global Variables
    var tempTours: [Tour] = []
    var tourCatName:String = ""
    
    
    //MARK: System Functions
    override func viewDidLoad() {
        
        //Set the title of the window to the tour category name
        self.navigationItem.title = self.tourCatName
        
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    //MARK: Table View Functions
    
    //Return the number of cells in a table
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tempTours.count
    }
    //Configure the cells
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tourCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = tempTours[indexPath.row].getName()
        return cell
    }
    
    //Perform segue if user taps on a cell
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        self.performSegueWithIdentifier("tourDetail", sender: self)
        
    }
    
    //MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
            
            if segue.identifier == "tourDetail"
            {
                //Set the proper details for the next VC
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    let controller = (segue.destinationViewController as! SelectedTourViewController)
                    controller.selectedTour = tempTours[indexPath.row]
                }
            }

        } catch {
            //Change this to avoid deprecation. This is only temporary
            let alert = UIAlertController(title: "Warning!", message: "Check your internet Connection", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
                (_)in
                //self.performSegueWithIdentifier("cancelTour", sender: self)
            })
            
            alert.addAction(OKAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
}

