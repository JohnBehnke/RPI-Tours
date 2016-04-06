//
//  SettingsViewController.swift
//  RPI Tours
//
//  Created by John Behnke on 3/30/16.
//  Copyright © 2016 RPI Web Tech. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    @IBOutlet var measurementTypeSelector: UISegmentedControl!
    
    @IBAction func triggeredSave(sender: AnyObject) {
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setObject(measurementTypeSelector.titleForSegmentAtIndex(measurementTypeSelector.selectedSegmentIndex), forKey: "system")
        
    }
    
    @IBOutlet var accuracySlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
