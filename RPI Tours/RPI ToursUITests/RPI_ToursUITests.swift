//
//  RPI_ToursUITests.swift
//  RPI ToursUITests
//
//  Created by John Behnke on 2/6/16.
//  Copyright © 2016 RPI Web Tech. All rights reserved.
//

import XCTest

class RPI_ToursUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    // This test case is to make sure that the map button works as intended
    func testmapbutton(){
        let app = XCUIApplication() //launch app
        app.navigationBars["Tour Categories"].buttons["Map"].tap() //go to map
        app.otherElements["Map"].tap() //move around the map to make sure everything renders
        app.navigationBars["Map of Campus"].childrenMatchingType(.Button).matchingIdentifier("Back").elementBoundByIndex(0).tap() //back to main screen
    }
    
    // This test case checks to make sure that a user can select a tour without issue
    func testselecttour(){
        let app = XCUIApplication() //launch app
        let tablesQuery = app.tables //display category tables
        tablesQuery.staticTexts["Example Category"].tap() //select a category
        tablesQuery.staticTexts["Example Tour for SD&D"].tap() //select a tour
        app.navigationBars["Master"].buttons["Example Category"].tap() //back to tours list in category
        app.navigationBars.containingType(.StaticText, identifier:"Example Category").childrenMatchingType(.Button).matchingIdentifier("Back").elementBoundByIndex(0).tap() //back to categories
    }
    
    //This test case is to make sure that the "take tour" button takes the user on a tour when tapped
    func testtaketour(){
        let app = XCUIApplication() //launch app
        let tablesQuery = app.tables //display category tables
        tablesQuery.staticTexts["Example Category"].tap() //select a category
        tablesQuery.staticTexts["Example Tour2"].tap() //select a tour
        tablesQuery.buttons["Start Tour"].tap() //start tour
        let masterNavigationBar = app.navigationBars["Master"] //move the map to check for rendering issues
        masterNavigationBar.childrenMatchingType(.Button).matchingIdentifier("Back").elementBoundByIndex(0).tap() //back to tour information page
        masterNavigationBar.buttons["Example Category"].tap() //back to tours list in category
        app.navigationBars.containingType(.StaticText, identifier:"Example Category").childrenMatchingType(.Button).matchingIdentifier("Back").elementBoundByIndex(0).tap() //back to categories
    }
    
    //This test case is to make sure that the landmark pins display correctly
    func testviewpin(){
        let app = XCUIApplication() //launch app
        app.navigationBars["Tour Categories"].buttons["Map"].tap() //go to map
        app.otherElements["Map"].tap() //tap on a pin to see if correct information displays
        app.navigationBars["Map of Campus"].childrenMatchingType(.Button).matchingIdentifier("Back").elementBoundByIndex(0).tap()//back to main screen
    }
    
    //This test case is to make sure that the category information displays correctly
    func testcategoryinfo(){
        let app = XCUIApplication() //launch app
        let tablesQuery = app.tables //display category tables
        tablesQuery.buttons["More Info, Example Category"].tap() //tap the information button on the tour category
        
        let table = app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).elementBoundByIndex(0).childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Table).element //create and display information window on top of table
        table.tap() //exit window
        tablesQuery.buttons["More Info, Example Category2"].tap() //tap the information button on the other tour category and display on top of table
        table.tap() //exit window
    }
    
}
