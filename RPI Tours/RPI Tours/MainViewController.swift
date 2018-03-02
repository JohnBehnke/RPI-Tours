//
//  MainViewController.swift
//  RPI Tours
//
//  Created by Jacob Speicher on 2/27/18.
//  Copyright © 2018 RPI Web Tech. All rights reserved.
//

import UIKit
import ReachabilitySwift
import Alamofire

private let reuseIdentifier = "Cell"


class MainViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout  {

    var choices = ["Tours", "Points of Interest"]
    var choice_images = ["https://i.imgur.com/nPlXrsX.jpg", "https://i.imgur.com/C3EaTx8.jpg"]
    //var choice_images = ["https://farm5.static.flickr.com/4044/4188687632_c3e7a6222b_b.jpg", "https://upload.wikimedia.org/wikipedia/commons/3/30/Rice_Building_Troy.jpg"]
    
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
        //cell.backgroundColor = Constants.Colors.UI.background
        
        cell.cellText.text = self.choices[indexPath.item]
        cell.cellText.sizeToFit()
        //cell.cellText.textAlignment = .center
        //cell.cellText.center = cell.contentView.center
        
        cell.cellImage.af_setImage(withURL: NSURL(string: self.choice_images[indexPath.item])! as URL)
        cell.cellImage.contentMode = .scaleAspectFill
        cell.cellImage.alpha = 0.8
        
    
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
                        let vc = SettingsViewController()
                        self.present(vc, animated: true, completion: nil)
                    }
                    else{
                        let vc = SettingsViewController()
                        self.present(vc, animated: true, completion: nil)
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
