//
//  RickAndMortyAppUITests.swift
//  RickAndMortyAppUITests
//
//  Created by Руслан Забиран on 2.09.24.
//

import XCTest

final class RickAndMortyAppUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("UITesting")
        app.launch()
        sleep(3)

    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testForSearching() throws {
        
        let searchTextField = app.scrollViews.textFields["searchTextField"]
        XCTAssertTrue(searchTextField.exists)
        searchTextField.tap()
        
        searchTextField.typeText("Mr. Nimbus")
        
        let searchButton = app.buttons["Search"]
        XCTAssert(searchButton.exists)
        searchButton.tap()
        
        sleep(1)
        
        let nameLabel = app.staticTexts["Mr. Nimbus"]
        XCTAssert(nameLabel.exists)
    }
    
    func testNavigateToDetail() {

        let collectionView = app.scrollViews.otherElements.collectionViews.element(boundBy: 0)
        XCTAssert(collectionView.exists)
        
        let cell = collectionView.cells.element(boundBy: 0)
        XCTAssert(cell.exists)
        
        cell.tap()
        
        let nameLabel = app.staticTexts["Rick Sanchez"]
        XCTAssert(nameLabel.exists)
        
    }
    
    func testNavigateToFavorites() {
        
        let tabBar = app.tabBars["Tab Bar"]
        XCTAssert(tabBar.exists)
        
        let favoriteButton = tabBar.buttons.element(boundBy: 1)
        XCTAssert(favoriteButton.exists)
        
        favoriteButton.tap()
        
        let text = app.staticTexts["Favorite characters"]
        XCTAssert(text.exists)
        
    }
    
}
