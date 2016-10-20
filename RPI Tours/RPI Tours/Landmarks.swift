//
//  Landmarks.swift
//
//
//  Created by David Ivey on 3/18/16.
//
//

import UIKit
//Inherit from Waypoint becuase OOP
class Landmark: tourWaypoint {
    
    //INITIALIZERS
    init(name: String, desc: String, lat: Double, long: Double) {
        
        self.name = name
        self.desc = desc
        self.urls = []
        super.init(lat: lat,long: long)
    }
    
    override init() {
        
        self.name = ""
        self.desc = ""
        self.urls = []
        super.init()
    }
    
    //GETTERS
    func getName() -> String {
        return name
    }
    func getDesc() -> String {
        return desc
    }
    func getImages() -> [UIImage] {
        var images: [UIImage] = []
        
        for i in urls {
            let url = NSURL(string: i)
            let data = NSData(contentsOfURL: url!)
            images.append(UIImage(data: data!)!)
        }
        
        return images
    }

    
    
    //SETTERS
    func setName(name:String) {
        self.name = name
    }
    func setDesc(desc:String) {
        self.desc = desc
    }
    func setImages(urls:[String]) {
        self.urls = urls
    }

    
    
    //VARIABLES
    private var name: String
    private var desc: String
    private var urls: [String]

    
}
