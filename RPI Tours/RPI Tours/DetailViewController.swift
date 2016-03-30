//
//  ToursByCategoryViewController
//  RPI Tours
//
//  Created by John Behnke on 2/6/16.
//  Copyright © 2016 RPI Web Tech. All rights reserved.
//

import UIKit

import CoreLocation

class ToursByCategoryViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    
    var tempTours: [String] = ["Freshman Living", "Sophomore Living", "Dining Options", "Academic Buildings"]
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    
    @IBOutlet weak var attributionTextView: UITextView!
    
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    
   
    
    
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.valueForKey("timeStamp")!.description
            }
        }
    }
    
    override func viewDidLoad() {
        
        
        
        
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        let sectionInfo = self.fetchedResultsController.sections![section]
        //        return sectionInfo.numberOfObjects
        return tempTours.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tourCell", forIndexPath: indexPath)
        //self.configureCell(cell, atIndexPath: indexPath)
        cell.textLabel?.text = tempTours[indexPath.row]
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
            self.performSegueWithIdentifier("tourDetail", sender: self)
        
           }
    
    
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "tourDetail"
        {
            let vc = segue.destinationViewController 
            
            let controller = vc.popoverPresentationController
            
            if controller != nil
            {
                controller?.delegate = self
            }
        }
    }

    
    
}

