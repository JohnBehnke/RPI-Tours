//
//  TourCat.swift
//
//
//  Created by David Ivey on 3/18/16.
//
//



class TourCat {
    
    
    //INITIALIZERS
    init(name: String, desc: String, tours: [Tour]) {
        self.name = name
        self.desc = desc
        self.tours = tours
        
    }
    //empty Init
     init() {
        self.name = ""
        self.desc = ""
        self.tours = []
    }
    
    //GETTERS
    func getName() -> String{
        return name
    }
    func getDesc() ->String {
        return desc
    }
    func getTours() -> [Tour] {
        return tours
    }
    
    //SETTERS
    func setName(_ name:String) {
        self.name = name
    }
    func setDesc(_ desc:String) {
        self.desc = desc
    }
    func setTours(_ tours: [Tour]) {
        self.tours = tours
    }
    
    //Priavte VARIABLES
    fileprivate var name: String
    fileprivate var desc: String
    fileprivate var tours: [Tour]
}
