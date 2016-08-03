//
//  InfoViewController.swift
//  RPI Tours
//
//  Created by Jacob Speicher on 8/1/16.
//  Copyright © 2016 RPI Web Tech. All rights reserved.
//

import UIKit
import ReachabilitySwift
import CoreLocation

class InfoViewController: UITableViewController {
    
    //MARK: IBOutlets
    @IBOutlet var landmarkDescriptionLabel: UILabel!
    
    //MARK: Global Variables
    var landmarkName:String = ""
    var landmarkDesc:String = ""
    var landmarkInformation: [Landmark] = []
    
    //MARK: System Functions
    override func viewDidLoad() {
        self.navigationItem.title = self.landmarkName
        
        let chosenLandmark = searchForLandmark()
        
        self.landmarkDescriptionLabel.text = chosenLandmark.getDesc()
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Helper Functions
    func searchForLandmark() -> Landmark {
        for landmark in landmarkInformation {
            if landmark.getName() == self.landmarkName {
                return landmark
            }
        }
        
        return Landmark(name: "landmarkName", desc: "I'm sorry, there is no information yet for this landmark.", lat: 0.0, long: 0.0)
    }
}
