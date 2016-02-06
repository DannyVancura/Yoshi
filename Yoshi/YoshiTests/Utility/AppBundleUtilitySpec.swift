//
//  AppBundleUtilitySpec.swift
//  Yoshi
//
//  Created by Michael Campbell on 2/4/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import XCTest
@testable import Yoshi

class AppBundleUtilitySpec: XCTestCase {

    var appVersionText: String!

    override func setUp() {
        super.setUp()
        appVersionText = AppBundleUtility.appVersionText()
    }

    override func tearDown() {
        appVersionText = nil
        super.tearDown()
    }

    func testAppVersionTextIncludesDisplayName() {
        let appDisplayName = NSBundle.mainBundle()
            .objectForInfoDictionaryKey(appDisplayNameDictionaryKey) as? String ?? ""

        XCTAssertTrue(appVersionText.containsString(appDisplayName),
            "\(appVersionText) does not include \(appDisplayName)")
    }

    func testAppVersionTextIncludesAppVersionNumber() {
        let appVersionText = AppBundleUtility.appVersionText()
        let appVersionNumber = NSBundle.mainBundle()
            .objectForInfoDictionaryKey(appVersionNumberDictionaryKey) as? String ?? ""

        XCTAssertTrue(appVersionText.containsString(appVersionNumber),
            "\(appVersionText) does not include \(appVersionNumber)")
    }

    func testAppVersionTextIncludesAppBuildNumber() {
        let appVersionText = AppBundleUtility.appVersionText()
        let appBuildNumber = NSBundle.mainBundle()
            .objectForInfoDictionaryKey(appBuildNumberDictionaryKey) as? String ?? ""

        XCTAssertTrue(appVersionText.containsString(appBuildNumber),
            "\(appVersionText) does not include \(appBuildNumber)")
    }

}

private extension String {

    func containsString(stringToFind: String) -> Bool {
        return self.rangeOfString(stringToFind) != nil
    }

}
