//
//  TourCategoryViewController.swift
//  RPI Tours
//
//  Created by John Behnke on 2/6/16.
//  Copyright © 2016 RPI Web Tech. All rights reserved.
//

import UIKit
import CoreData
import ReachabilitySwift

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
                if let indexPath = self.tableView.indexPathForSelectedRow { //get the indexpath for the selected row
                    //                let controller = (segue.destination as! UINavigationController).topViewController as! ToursByCategoryViewController //Create the detailVC

                    let controller = segue.destination as! ToursByCategoryViewController
                    controller.toursInCategory = tourCategories[indexPath.row].tours//Set the detailVC detail item to the object
                    controller.tourCatName = tourCategories[indexPath.row].name
                    controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                    controller.navigationItem.leftItemsSupplementBackButton = true //Make a back button
                }

            default:
                return

            }

            //swiftlint:enable line_length
        }
    }

    // MARK: Table View Functions

    //This function deals with displaying a TourCatDetail View Controller when the user taps on the "i"
    //No Return
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {

        let vc = UIViewController()
        //Load it
        descLabel.text = tourCategories[indexPath.row].desc

        vc.view.addSubview(testView)
        vc.view.sizeThatFits(testView.bounds.size)
        vc.preferredContentSize = testView.bounds.size

        //Set the text to the desc
        //Present it
        vc.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        popover.sourceView = tableView.cellForRow(at: indexPath)?.contentView
        popover.sourceRect = (tableView.cellForRow(at: indexPath)?.bounds)!
        popover.delegate = self

        present(vc, animated: true, completion:nil)
    }

    //Returns the count of how many tour categories exist
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.tourCategories.count
    }

    //Configures a cell to be displayed
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "catCell", for: indexPath)

        cell.textLabel?.text = tourCategories[indexPath.row].name
        let numTours = tourCategories[indexPath.row].tours.count

        cell.detailTextLabel?.text = "\(numTours.description) available tours"
        return cell
    }

    //Deals with a user tapping a cell. Either starts a segue to the next VC, or fails b/c no internet
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let reachability = Reachability()!

        reachability.whenReachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async {
                if reachability.isReachable {
                    self.performSegue(withIdentifier: "showDetail", sender: self)
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
                //self.performSegueWithIdentifier("cancelTour", sender: self)
            })

            alert.addAction(OKAction)
            self.present(alert, animated: true, completion: nil)

        }

        do {
            try reachability.startNotifier()
        } catch {
        }
    }
    
    // MARK: Popover Functions
    //Small helper function
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
        
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
