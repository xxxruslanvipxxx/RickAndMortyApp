//
//  RickAndMortyAppUITestsLaunchTests.swift
//  RickAndMortyAppUITests
//
//  Created by Руслан Забиран on 2.09.24.
//

import XCTest

final class RickAndMortyAppUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testLaunchPerformance() {
            if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
                measure(metrics: [XCTApplicationLaunchMetric()]) {
                    XCUIApplication().launch()
                }
            }
        }
    
}
