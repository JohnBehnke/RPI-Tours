//
//  SettingsViewController.swift
//  RPI Tours
//
//  Created by John Behnke on 3/30/16.
//  Copyright © 2016 RPI Web Tech. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    let defaults = UserDefaults.standard

    
    //MARK: IBOutlets
    
    @IBOutlet var measurementTypeSelector: UISegmentedControl!
    @IBOutlet var accuracySlider: UISlider!
    
    
    //MARK: IBActions
    //Save any settings
    @IBAction func triggeredSave(_ sender: AnyObject) {
        
        //Load the store
        
        //Set the setting
        self.defaults.set(measurementTypeSelector.titleForSegment(at: measurementTypeSelector.selectedSegmentIndex), forKey: "system")
        self.defaults.set(measurementTypeSelector.selectedSegmentIndex, forKey: "savedIndex")
        
        //Prompt the user with an alert
        let alert = UIAlertController(title: "System", message: "Settings Saved!", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            (_)in
            //self.performSegueWithIdentifier("cancelTour", sender: self)
        })
        //Present the alert
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: System Functions
    override func viewDidLoad() {
        
        if self.defaults.object(forKey: "savedIndex") != nil{
            
        self.measurementTypeSelector.selectedSegmentIndex = ((self.defaults.object(forKey: "savedIndex")) as? Int)!
        }

        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
