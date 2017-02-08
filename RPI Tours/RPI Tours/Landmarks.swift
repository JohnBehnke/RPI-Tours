//
//  Landmarks.swift
//
//
//  Created by David Ivey on 3/18/16.
//
//

import UIKit
//Inherit wrom Waypoint becuase OOP
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
            let url = URL(string: i)
            let data = try? Data(contentsOf: url!)
            images.append(UIImage(data: data!)!)
        }
        
        return images
    }

    
    
    //SETTERS
    func setName(_ name:String) {
        self.name = name
    }
    func setDesc(_ desc:String) {
        self.desc = desc
    }
    func setImages(_ urls:[String]) {
        self.urls = urls
    }

    
    
    //VARIABLES
    fileprivate var name: String
    fileprivate var desc: String
    fileprivate var urls: [String]

    
}
