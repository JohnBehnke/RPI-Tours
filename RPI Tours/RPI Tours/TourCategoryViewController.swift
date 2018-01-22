//
//  TourCategoryViewController.swift
//  RPI Tours
//
//  Created by John Behnke on 2/6/16.
//  Copyright © 2016 RPI Web Tech. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class TourCategoryViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

    // MARK: Globals
    var detailViewController: ToursByCategoryViewController? //used for send information to the DetailVC

    //Array to hold tour categories objects
    var tourCategories: [TourCat] = []

    @IBOutlet weak var testView: UILabel!
    @IBOutlet var descLabel: UILabel!

    // MARK: System Functions
    override func viewDidLoad() {

        super.viewDidLoad()

        UIApplication.shared.statusBarStyle = .lightContent
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }


        getTourCategories(completion: {
            (result: [TourCat]) in

            self.tourCategories = result

            DispatchQueue.main.async{
                self.tableView.reloadData()

            }

        })


    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    //this is gonna have to be used soon (John)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //swiftlint:disable line_length
        if let identifier = segue.identifier {
            switch identifier {
            case "showDetail":
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    let controller = segue.destination as! ToursByCategoryViewController
                    controller.toursInCategory = tourCategories[indexPath.row].tours
                    controller.tourCatName = tourCategories[indexPath.row].name
                    controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                    controller.navigationItem.leftItemsSupplementBackButton = true
                }

            default:
                return

            }

        }
    }

    // MARK: Table View Functions

   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.tourCategories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "catCell", for: indexPath)

        cell.textLabel?.text = tourCategories[indexPath.row].name
        let numTours = tourCategories[indexPath.row].tours.count

        cell.detailTextLabel?.text = "\(numTours.description) available tours"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        if NetworkReachabilityManager()!.isReachable{
            self.performSegue(withIdentifier: "showDetail", sender: self)
        } else{
            let alert = UIAlertController(title: "Warning!", message: "Check your internet Connection", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        
    }
}
