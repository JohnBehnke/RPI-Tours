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
import TNImageSliderViewController

class InfoViewController: UITableViewController {
    
    //MARK: IBOutlets
    @IBOutlet var landmarkDescriptionLabel: UILabel!
    @IBOutlet var descriptionCell: UITableViewCell!
    
    //MARK: Global Variables
    var landmarkName:String = ""
    var landmarkDesc:String = ""
    var landmarkInformation: [Landmark] = []
    var imageSliderVC: TNImageSliderViewController!
    var cameFromMap:Bool = false
    
    //MARK: Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "imageSlider" {
            imageSliderVC = segue.destination as! TNImageSliderViewController
        }
    }
    
    //MARK: System Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.landmarkName
        
        let chosenLandmark = searchForLandmark()
        
        self.landmarkDescriptionLabel.text = chosenLandmark.getDesc()
        
        //Does this async call work?
        self.imageSliderVC.images = []
        for url in chosenLandmark.getImageURLs(){
            URLSession.shared.dataTask(with: NSURL(string: url)! as URL, completionHandler: { (data, response, error) -> Void in
                
                if error != nil {
                    print(error!)
                    return
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    let image = UIImage(data: data!)
                    if let tom = image{
                        var temp = self.imageSliderVC.getImages()
                        
                        temp.append(tom)
                        
                        self.imageSliderVC.images = temp
                        self.imageSliderVC.reloadInputViews()
                    }
                    
                })
                
            }).resume()
        }
        
        
        
        //set the imageSlider options
        var options = TNImageSliderViewOptions()
        options.pageControlHidden = false
        options.scrollDirection = .horizontal
        options.shouldStartFromBeginning = true
        options.imageContentMode = .scaleAspectFit
        options.pageControlCurrentIndicatorTintColor = UIColor.red
        
        
        imageSliderVC.options = options
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Helper Functions
    func searchForLandmark() -> Landmark {
        for landmark in landmarkInformation {
            if landmark.getName() == self.landmarkName && !landmark.getDesc().isEmpty{
                return landmark
            }
        }
        
        let blankLandmark = Landmark(name: "Unknown Landmark", desc: "I'm sorry, there is no information yet for this landmark.", lat: 0.0, long: 0.0)
//        blankLandmark.setImages(["https://c1.staticflickr.com/5/4034/4544827697_6f73866999_b.jpg"])
        
        return blankLandmark
    }
    
    //MARK: TableView Functions
    
    
    override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 500
        }
        
        return 300
    }
    
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 500
        }
        
        return 300
    }
}
