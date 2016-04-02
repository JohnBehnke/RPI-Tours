//
//  TourCat.swift
//
//
//  Created by David Ivey on 3/18/16.
//
//

import UIKit

class TourCat {
    
    
    //INITIALIZERS
    init(name: String, desc: String, tours: [Tour]) {
        self.name = name
        self.desc = desc
        self.tours = tours
        
    }
    
    override init() {
        self.name = ""
        self.desc = ""
        self.tours = nil
    }
    
    //GETTERS
    func getName() {
        return name
    }
    func getDesc() {
        return desc
    }
    func getTours() {
        return tours
    }
    
    //SETTERS
    func setName(name:String) {
        self.name = name
    }
    func setDesc(desc:String) {
        self.desc = desc
    }
    func setTours(tours: [Tour]) {
        self.tours = tours
    }
    
    //VARIABLES
    private var name: String
    private var desc: String
    private var tours: [Tour]
}