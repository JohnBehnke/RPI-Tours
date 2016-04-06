//
//  TourCategoryDetailViewController.swift
//  RPI Tours
//
//  Created by John Behnke on 3/26/16.
//  Copyright © 2016 RPI Web Tech. All rights reserved.
//

import UIKit

class TourCategoryDetailViewController: UIViewController {
    
    //MARK: Globals
    var label:UILabel?
    
    //MARK: System Functions
    override func viewDidLoad() {
        label = UILabel(frame: CGRectMake(0, 0, 200, 21))
        label!.center = CGPointMake(160, 284)
        label!.textAlignment = NSTextAlignment.Center
        
        self.view.addSubview(label!)
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    //MARK: Helper Function
    
    //Set the text label
    func setText(input:String)  {
        
        self.label!.text = input
    }

    

}
