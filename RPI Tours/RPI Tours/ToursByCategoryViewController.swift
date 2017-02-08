//
//  ToursByCategoryViewController
//  RPI Tours
//
//  Created by John Behnke on 2/6/16.
//  Copyright © 2016 RPI Web Tech. All rights reserved.
//

import UIKit
import ReachabilitySwift
import CoreLocation

class ToursByCategoryViewController: UITableViewController{
    
    //MARK: IBAction
    //Rewind point for going back to this VC
    @IBAction func unwindToMenu(_ segue: UIStoryboardSegue) {
        self.navigationController?.isNavigationBarHidden = false
        
        //sets status bar and navigation bar to the same color
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.backgroundColor = self.navigationController?.navigationBar.backgroundColor
    }
    
    //MARK: Global Variables
    var tempTours: [Tour] = []
    var tourCatName:String = ""
    
    
    //MARK: System Functions
    override func viewDidLoad() {
        
        //Set the title of the window to the tour category name
        self.navigationItem.title = self.tourCatName
        
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    //MARK: Table View Functions
    
    //Return the number of cells in a table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tempTours.count
    }
    //Configure the cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tourCell", for: indexPath)
        
        cell.textLabel?.text = tempTours[indexPath.row].getName()
        return cell
    }
    
    //Perform segue if user taps on a cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        self.performSegue(withIdentifier: "tourDetail", sender: self)
        //        self.prepare(for: .withIdentifier: "tourDetail", sender: self)
        
    }
    
    //MARK: Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let reachability = Reachability()!
        
        reachability.whenReachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            
            
            if segue.identifier == "tourDetail"
            {
                //Set the proper details for the next VC
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    print(self.tempTours[indexPath.row])
                    print("111")
                    
                    
                    let controller = (segue.destination as! SelectedTourViewController)
                    controller.selectedTour = self.tempTours[indexPath.row]
                }
            }
            
        }
        reachability.whenUnreachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            
            let alert = UIAlertController(title: "Warning!", message: "Check your internet Connection", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (_)in
                //self.performSegueWithIdentifier("cancelTour", sender: self)
            })
            
            alert.addAction(OKAction)
            self.present(alert, animated: true, completion: nil)
            
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
        
    }
    
    
}

