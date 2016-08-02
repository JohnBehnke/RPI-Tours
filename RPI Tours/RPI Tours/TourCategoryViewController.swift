//
//  TourCategoryViewController.swift
//  RPI Tours
//
//  Created by John Behnke on 2/6/16.
//  Copyright © 2016 RPI Web Tech. All rights reserved.
//

import UIKit
import CoreData
import ReachabilitySwift


class TourCategoryViewController: UITableViewController, NSFetchedResultsControllerDelegate,UIPopoverPresentationControllerDelegate {
    
    
    //MARK: Globals
    var detailViewController: ToursByCategoryViewController? = nil //used for send information to the DetailVC
    
    //Array to hold tour categories objects
    var tourCategories: [TourCat] = []
    
    @IBOutlet var descLabel: UILabel!
    
    @IBOutlet var testView: UIView!
    
    //MARK: System Functions
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        //This is for split views for iPads. We aren't going to need this!
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? ToursByCategoryViewController
        }
        
        //Call the JSON parser and append the parsed tour categories to the tourCategories Array
        self.tourCategories = jsonParser()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed //Just for the iPad swag
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Segues
    
    //this is gonna have to be used soon (John)
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier == "showDetail" { //(John) If wr are about to go into the detail segue
            if let indexPath = self.tableView.indexPathForSelectedRow { //get the indexpath for the selected row
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! ToursByCategoryViewController //Create the detailVC
                controller.tempTours = tourCategories[indexPath.row].getTours()//Set the detailVC detail item to the object
                controller.tourCatName = tourCategories[indexPath.row].getName()
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem ()
                controller.navigationItem.leftItemsSupplementBackButton = true //Make a back button
            }
        }
        
        
    }
    
    //MARK: Table View Functions
    
    //This function deals with displaying a TourCatDetail View Controller when the user taps on the "i"
    //No Return
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        
        //This adds the popup for when the user selects the accessory detail for a tour cat desc
        
        //Make a Detail VC
        let vc = UIViewController()
        //Load it
        descLabel.text = tourCategories[indexPath.row].getDesc()
       
        
        vc.view.addSubview(testView)
        vc.view.sizeThatFits(testView.bounds.size)
        vc.preferredContentSize = testView.bounds.size
       
        //Set the text to the desc
                //Present it
        vc.modalPresentationStyle = UIModalPresentationStyle.Popover
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        popover.sourceView = tableView.cellForRowAtIndexPath(indexPath)?.contentView
        popover.sourceRect = (tableView.cellForRowAtIndexPath(indexPath)?.bounds)!
        popover.delegate = self
        
        presentViewController(vc, animated: true, completion:nil)
    }
    
    
    //Returns the count of how many tour categories exist
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.tourCategories.count
    }
    
    //Configures a cell to be displayed
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("catCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = tourCategories[indexPath.row].getName()
    let numTours = tourCategories[indexPath.row].getTours().count
        
        cell.detailTextLabel?.text = "\(numTours.description) available tours"
        return cell
    }
    
    //Deals with a user tapping a cell. Either starts a segue to the next VC, or fails b/c no internet
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let reachability: Reachability
        
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
            
            //If we have internet, go to the next VC
            self.performSegueWithIdentifier("showDetail", sender: self)
            
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
    
    //MARK: Popover Functions
    //Small helper function
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
        
    }
    
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}

