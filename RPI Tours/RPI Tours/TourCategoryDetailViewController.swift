//
//  TourCategoryDetailViewController.swift
//  RPI Tours
//
//  Created by John Behnke on 3/26/16.
//  Copyright © 2016 RPI Web Tech. All rights reserved.
//

import UIKit

class TourCategoryDetailViewController: UIViewController {

    //@IBOutlet var catDesc: UITextView!
    var label:UILabel?
    
    override func viewDidLoad() {
        label = UILabel(frame: CGRectMake(0, 0, 200, 21))
        label!.center = CGPointMake(160, 284)
        label!.textAlignment = NSTextAlignment.Center
        label!.text = "I'am a test label"
        self.view.addSubview(label!)
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setText(input:String)  {
        
        self.label!.text = input
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
