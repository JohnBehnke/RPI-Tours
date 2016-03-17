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

    var detailViewController: DetailViewController? = nil //(John) used for send information to the DetailVC
    var managedObjectContext: NSManagedObjectContext? = nil //(John)This is basically for CoreData. Think of it as a scratchpad for saving things

    
    var tempTourCats: [String] = ["General Tours","Athletics Tour","Tour by Major", "Alumni Tours"]
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
                UIApplication.sharedApplication().statusBarStyle = .LightContent
        //(John)This is for split views for iPads. We aren't going to need this!
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed //(John) Just for the iPad swag
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //(John) Keep for refernce on how to do some core data workings
//    func insertNewObject(sender: AnyObject) {
//        let context = self.fetchedResultsController.managedObjectContext //request the save instance
//        let entity = self.fetchedResultsController.fetchRequest.entity! //request the specific entity
//        let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName(entity.name!, inManagedObjectContext: context) //make a new managed object
//             
//        // If appropriate, configure the new managed object.
//        // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
//        newManagedObject.setValue(NSDate(), forKey: "timeStamp") //set the "timestamp" attribute to the current date
//             
//        // Save the context.
//        do {
//            try context.save()
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            //print("Unresolved error \(error), \(error.userInfo)")
//            abort()
//        }
//    }

    // MARK: - Segues

    //this is gonna have to be used soon (John)
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "showDetail" { //(John) If wr are about to go into the detail segue
//            if let indexPath = self.tableView.indexPathForSelectedRow { //get the indexpath for the selected row
//            let object = self.fetchedResultsController.objectAtIndexPath(indexPath) //uses index paths (having a row and a section component) so that it can be used as a data source for table views with multiple sections.
//                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController //Create the detailVC
//                controller.detailItem = object //Set the detailVC detail item to the object
//                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem ()
//                controller.navigationItem.leftItemsSupplementBackButton = true //Make a back button
//            }
//        }
        
    } 

    // MARK: - Table View

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        //return self.fetchedResultsController.sections?.count ?? 0 //Try to get the count and unwrapit, or use 0
//        return 4
//    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let sectionInfo = self.fetchedResultsController.sections![section]
//        return sectionInfo.numberOfObjects
        return self.tempTourCats.count
    }
    
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        //self.configureCell(cell, atIndexPath: indexPath)
        cell.textLabel?.text = tempTourCats[indexPath.row]
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    

//    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
//        let object = self.fetchedResultsController.objectAtIndexPath(indexPath)
//        cell.textLabel!.text = object.valueForKey("timeStamp")!.description
//    }

    // MARK: - Fetched results controller

    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        } //
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("Event", inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        
        let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             //print("Unresolved error \(error), \(error.userInfo)")
             abort()
        }
        
        return _fetchedResultsController!
    }    
    var _fetchedResultsController: NSFetchedResultsController? = nil

    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("TourCategoryDetailViewController")
        vc.modalPresentationStyle = UIModalPresentationStyle.Popover
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
       
        popover.sourceView = tableView.cellForRowAtIndexPath(indexPath)?.contentView
        popover.sourceRect = (tableView.cellForRowAtIndexPath(indexPath)?.bounds)!
        popover.delegate = self
        presentViewController(vc, animated: true, completion:nil)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
        
    }
    
    
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
     // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
         // In the simplest, most efficient, case, reload the table view.
         self.tableView.reloadData()
     }
     */

}

