//
//  RPI_ToursTests.swift
//  RPI ToursTests
//
//  Created by John Behnke on 2/6/16.
//  Copyright © 2016 RPI Web Tech. All rights reserved.
//

import XCTest
@testable import RPI_Tours

class RPI_ToursTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //check to see if there is a correct number of tour categories
    func testTourCatjsonParser(){
        let test = jsonParser()
        //the number on the right of the double equal sign is a hardcoded value set to the expected number of tour categories
        XCTAssertTrue(test.count == 2)
    }
    
    //check to see if there is a correct number of tours in each of the categories
    func testToursjsonParser(){
        let TourCattest = jsonParser()
        
        let TourCat1 = TourCattest[0].getTours()
        //the number on the right of the double equal sign is a hardcoded value set to the expected number of tours within the category
        XCTAssertTrue(TourCat1.count == 2)
        
        let TourCat2 = TourCattest[1].getTours()
        //the number on the right of the double equal sign is a hardcoded value set to the expected number of tours within the category
        XCTAssertTrue(TourCat2.count == 2)
    }
    
    //test to see if the csv is built correctly
    func testCSV(){
        let test = buildCSV()
        XCTAssertTrue(test.count == 86)
    }
    
    //test to ensure network connectivity
    func testNetwork(){
        let test = isConnectedToNetwork()
        XCTAssertTrue(test)
    }
    
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }

    
    //test to see the speed at which different tasks are preformed. uncomment one at a time to test each item
    func testPerformanceExample() {
//        self.measureBlock {let testjP = jsonParser()} //parsing json file
//        self.measureBlock {let testbcsv = buildCSV()} //building csv
//        self.measureBlock {let testconnect = isConnectedToNetwork()} //connecting to internet
//        self.measureBlock {let testconversion = metersToFeet(8888)} //unit conversion
    }
}


