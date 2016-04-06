//
//  TourCategoryViewController.swift
//  RPI Tours
//
//  Created by John Behnke on 2/6/16.
//  Copyright © 2016 RPI Web Tech. All rights reserved.
//

import UIKit
import CoreData


class TourCategoryViewController: UITableViewController, NSFetchedResultsControllerDelegate,UIPopoverPresentationControllerDelegate {
    
    var detailViewController: ToursByCategoryViewController? = nil //(John) used for send information to the DetailVC
    var managedObjectContext: NSManagedObjectContext? = nil //(John)This is basically for CoreData. Think of it as a scratchpad for saving things
    
    
    
    var tourCategories: [TourCat] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        //(John)This is for split views for iPads. We aren't going to need this!
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? ToursByCategoryViewController
        }
        
        
        tourCategories.append( jsonParser())
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed //(John) Just for the iPad swag
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
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        //let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = TourCategoryDetailViewController()
        vc.viewDidLoad()
        vc.setText(self.tourCategories[indexPath.row].getDesc())
        vc.modalPresentationStyle = UIModalPresentationStyle.Popover
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        
        popover.sourceView = tableView.cellForRowAtIndexPath(indexPath)?.contentView
        popover.sourceRect = (tableView.cellForRowAtIndexPath(indexPath)?.bounds)!
        popover.delegate = self
        
        presentViewController(vc, animated: true, completion:nil)
    }

    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.tourCategories.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("catCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = tourCategories[indexPath.row].getName()
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if isConnectedToNetwork() == false {
            //Change this to avoid deprecation. This is only temporary
            let alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()}
        else{
            self.performSegueWithIdentifier("showDetail", sender: self)
        }
    }
    
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
        
    }
    
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}

