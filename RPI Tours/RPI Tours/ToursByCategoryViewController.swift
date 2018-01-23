//
//  ToursByCategoryViewController
//  RPI Tours
//
//  Created by John Behnke on 2/6/16.
//  Copyright © 2016 RPI Web Tech. All rights reserved.
//

import Alamofire
import CoreLocation
import ReachabilitySwift
import UIKit

class ToursByCategoryViewController: UITableViewController {
    
    // MARK: IBAction
    @IBAction func unwindToMenu(_ segue: UIStoryboardSegue) {
        self.navigationController?.isNavigationBarHidden = false
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.backgroundColor = self.navigationController?.navigationBar.backgroundColor
    }
    
    // MARK: Class Variables
    var toursInCategory: [Tour] = []
    var tourCatName: String = ""
    
    // MARK: System Functions
    override func viewDidLoad() {
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        self.navigationItem.title = self.tourCatName
        
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: Table View Functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return toursInCategory.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tourCell", for: indexPath)
        
        cell.textLabel?.text = toursInCategory[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if NetworkReachabilityManager()!.isReachable{
            self.performSegue(withIdentifier: "tourDetail", sender: self)
        } else{
            let alert = UIAlertController(title: "Warning!", message: "Check your internet Connection", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        
    }
    // MARK: Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if let identifier = segue.identifier {
            switch identifier {
            case "tourDetail" :
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    let controller = (segue.destination as! SelectedTourViewController)
                    controller.selectedTour = self.toursInCategory[indexPath.row]
                }
            default: return
            }
        }
    }
}
