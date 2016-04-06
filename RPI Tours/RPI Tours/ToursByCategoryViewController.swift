//
//  ToursByCategoryViewController
//  RPI Tours
//
//  Created by John Behnke on 2/6/16.
//  Copyright © 2016 RPI Web Tech. All rights reserved.
//

import UIKit

import CoreLocation

class ToursByCategoryViewController: UITableViewController{
    
    //MARK: IBAction
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}
    
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
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tempTours.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tourCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = tempTours[indexPath.row].getName()
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        self.performSegueWithIdentifier("tourDetail", sender: self)
        
    }
    
    //MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "tourDetail"
        {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = (segue.destinationViewController as! SelectedTourViewController)
                controller.selectedTour = tempTours[indexPath.row]
            }
        }
        
    }
    
    
}

