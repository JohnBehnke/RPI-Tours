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

class ToursByCategoryViewController: UITableViewController {
    
    // MARK: IBAction
    //Rewind point for going back to this VC
    @IBAction func unwindToMenu(_ segue: UIStoryboardSegue) {
        self.navigationController?.isNavigationBarHidden = false
        
        //sets status bar and navigation bar to the same color
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.backgroundColor = self.navigationController?.navigationBar.backgroundColor
    }
    
    // MARK: Global Variables
    var toursInCategory: [Tour] = []
    var tourCatName: String = ""
    
    // MARK: System Functions
    override func viewDidLoad() {
        
        //Set the title of the window to the tour category name
        self.navigationItem.title = self.tourCatName

//        getAllTourForCat(url: <#T##String#>, numberOfTours: <#T##Int#>, completion: <#T##([Tour]) -> Void#>)

//        getTourCategories(completion: {
//            (result: [TourCat]) in
//
//            self.toursInCategory = result
////            print(self.tourCategories)
//            DispatchQueue.main.async{
//                self.tableView.reloadData()
//            }
//
//        })

        
        
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: Table View Functions
    
    //Return the number of cells in a table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return toursInCategory.count
    }
    //Configure the cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tourCell", for: indexPath)
        
        cell.textLabel?.text = toursInCategory[indexPath.row].name
        return cell
    }
    
    //Perform segue if user taps on a cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let reachability = Reachability()!
        
        reachability.whenReachable = { reachability in
            DispatchQueue.main.async {
                // this is called on a background thread, but UI updates must
                // be on the main thread, like this:
                if  reachability.isReachable {
                    self.performSegue(withIdentifier: "tourDetai;", sender: self)
                }
                
            }
            
        }
        reachability.whenUnreachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            
            let alert = UIAlertController(title: "Warning!",
                                          message: "Check your internet Connection",
                                          preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(_)in
                self.performSegue(withIdentifier: "cancelTour", sender: self)
            })
            
            alert.addAction(OKAction)
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tourDetail" {
            print("wjlfjkldsfjklsdjfksfkjs")
            
            //Set the proper details for the next VC
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                
                
                let controller = (segue.destination as! SelectedTourViewController)
                print("wjlfjkldsfjklsdjfksfkjs")
                print(self.toursInCategory[indexPath.row].waypoints)
                controller.selectedTour = self.toursInCategory[indexPath.row]
            }

        }
    }
    
    
    
}

// MARK: Segues



