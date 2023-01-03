//
//  ReposSearch_VIP_with_RxSwiftLaunchTests.swift
//  ReposSearch VIP with RxSwiftUITests
//
//  Created by Ali Fayed on 27/12/2022.
//

import XCTest

final class ReposSearch_VIP_with_RxSwiftLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
