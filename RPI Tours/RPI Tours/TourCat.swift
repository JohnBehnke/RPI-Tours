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
    func setName(name:String) {
        self.name = name
    }
    func setDesc(desc:String) {
        self.desc = desc
    }
    func setTours(tours: [Tour]) {
        self.tours = tours
    }
    
    //Priavte VARIABLES
    private var name: String
    private var desc: String
    private var tours: [Tour]
}