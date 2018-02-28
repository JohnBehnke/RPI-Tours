//
//  MainViewController.swift
//  RPI Tours
//
//  Created by Jacob Speicher on 2/27/18.
//  Copyright © 2018 RPI Web Tech. All rights reserved.
//

import UIKit
import ReachabilitySwift

private let reuseIdentifier = "Cell"


class MainViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout  {

    var choices = ["Tours", "Points of Interest"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.choices.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SelectCollectionViewCell
    
        // Configure the cell
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = Constants.Colors.UI.background.cgColor
        cell.layer.borderWidth = 1
        
        cell.cellText.text = self.choices[indexPath.item]
        cell.cellText.sizeToFit()
        cell.cellText.textAlignment = .center
        cell.cellText.center = cell.contentView.center
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.bounds.width
        let itemHeight = collectionView.bounds.height / 2.5
        return CGSize(width: itemWidth, height: itemHeight)
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let reachability = Reachability()!
        
        reachability.whenReachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async {
                if reachability.isReachable {
                    if indexPath.item == 0 {
                        self.performSegue(withIdentifier: "showTours", sender: self)
                    }
                    else{
                        self.performSegue(withIdentifier: "showPois", sender: self)
                    }
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
        return true
    }
    

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
