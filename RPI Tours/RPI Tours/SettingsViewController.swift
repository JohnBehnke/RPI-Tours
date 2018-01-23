//
//  SettingsViewController.swift
//  RPI Tours
//
//  Created by John Behnke on 3/30/16.
//  Copyright © 2016 RPI Web Tech. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    // MARK: Class Variables
    let defaults = UserDefaults.standard

    // MARK: IBOutlets

    @IBOutlet var measurementSelector: UISegmentedControl!
    
    // MARK: IBActions
    @IBAction func measurementToggle(_ sender: Any) {
        self.defaults.set(measurementSelector.titleForSegment(at: measurementSelector.selectedSegmentIndex), forKey: "system")
        self.defaults.set(measurementSelector.selectedSegmentIndex, forKey: "savedIndex")
    }
    
    // MARK: System Functions
    override func viewDidLoad() {

        if self.defaults.object(forKey: "savedIndex") != nil {
            self.measurementSelector.selectedSegmentIndex = ((self.defaults.object(forKey: "savedIndex")) as? Int)!
        }

        super.viewDidLoad()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
