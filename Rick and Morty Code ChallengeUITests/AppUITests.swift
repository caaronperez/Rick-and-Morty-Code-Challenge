//
//  AppUITests.swift
//  Rick and Morty Code Challenge
//
//  Created by Cristian Perez on 2/6/25.
//
import XCTest

final class AppUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
    }
    
    func testSearchFlow() {
        app.launch()
        
        // Testing the first screen launch
        XCTAssertTrue(app.staticTexts["Displaying main characters"].exists)
        
        // Search for Rick
        let searchField = app.textFields["Search"]
        searchField.tap()
        searchField.typeText("Rick")
        
        // Results validations
        let firstCell = app.staticTexts["Rick Sanchez"]
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
        
        // Check detail view
        firstCell.tap()
        XCTAssertTrue(app.staticTexts["Species"].exists)
        
        // Return to the main page
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }
}
