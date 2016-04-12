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
    
    func testTourCatjsonParser(){
        let test = jsonParser()
        XCTAssertTrue(test.count == 2)
    }
    
    func testToursjsonParser(){
        let TourCattest = jsonParser()
        
        let TourCat1 = TourCattest[0].getTours()
        XCTAssertTrue(TourCat1.count == 2)
        
        let TourCat2 = TourCattest[1].getTours()
        XCTAssertTrue(TourCat2.count == 2)
    }
    
    func testCSV(){
        let test = buildCSV()
        XCTAssertTrue(test.count == 86)
    }
    
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//    
    func testPerformanceExample() {
//        self.measureBlock {let testjP = jsonParser()}
//        self.measureBlock {let testbcsv = buildCSV()}
//        self.measureBlock {let testconnect = isConnectedToNetwork()}
//        self.measureBlock {let testconversion = metersToFeet(8888)}
    }
}


