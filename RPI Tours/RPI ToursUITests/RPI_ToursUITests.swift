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
    
    func testmapbutton(){
        let app = XCUIApplication()
        app.navigationBars["Tour Categories"].buttons["Map"].tap()
        app.otherElements["Map"].tap()
        app.navigationBars["Map of Campus"].childrenMatchingType(.Button).matchingIdentifier("Back").elementBoundByIndex(0).tap()
    }
    
    func testselecttour(){
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Example Category"].tap()
        
        let exampleTourForSdDStaticText = tablesQuery.staticTexts["Example Tour for SD&D"]
        exampleTourForSdDStaticText.tap()
        
        let masterNavigationBar = app.navigationBars["Master"]
        let exampleCategoryButton = masterNavigationBar.buttons["Example Category"]
        exampleCategoryButton.tap()
        
        let exampleTour2StaticText = tablesQuery.staticTexts["Example Tour2"]
        exampleTour2StaticText.tap()
        exampleCategoryButton.tap()
        app.navigationBars.containingType(.StaticText, identifier:"Example Category").childrenMatchingType(.Button).matchingIdentifier("Back").elementBoundByIndex(0).tap()
        tablesQuery.staticTexts["Example Category2"].tap()
        exampleTourForSdDStaticText.tap()
        
        let exampleCategory2Button = masterNavigationBar.buttons["Example Category2"]
        exampleCategory2Button.tap()
        exampleTour2StaticText.tap()
        exampleCategory2Button.tap()
        app.navigationBars.containingType(.StaticText, identifier:"Example Category2").childrenMatchingType(.Button).matchingIdentifier("Back").elementBoundByIndex(0).tap()
    }
    
    func testtaketour(){
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Example Category"].tap()
        tablesQuery.staticTexts["Example Tour2"].tap()
        tablesQuery.childrenMatchingType(.Other).elementBoundByIndex(2).otherElements["TOUR STATISTICS"].tap()
        tablesQuery.buttons["Start Tour"].tap()
        
        let masterNavigationBar = app.navigationBars["Master"]
        masterNavigationBar.childrenMatchingType(.Button).matchingIdentifier("Back").elementBoundByIndex(0).tap()
        masterNavigationBar.buttons["Example Category"].tap()
        app.navigationBars.containingType(.StaticText, identifier:"Example Category").childrenMatchingType(.Button).matchingIdentifier("Back").elementBoundByIndex(0).tap()
        
    }
    
    func testviewpin(){
        let app = XCUIApplication()
        app.navigationBars["Tour Categories"].buttons["Map"].tap()
        app.otherElements["Map"].tap()
        app.navigationBars["Map of Campus"].childrenMatchingType(.Button).matchingIdentifier("Back").elementBoundByIndex(0).tap()
    }
    
    func testcategoryinfo(){
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.buttons["More Info, Example Category"].tap()
        
        let table = app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).elementBoundByIndex(0).childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Table).element
        table.tap()
        tablesQuery.buttons["More Info, Example Category2"].tap()
        table.tap()
        
    }
    
}
