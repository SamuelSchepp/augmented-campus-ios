//
//  SceneTypeTests.swift
//  augmented-campus-ios
//
//  Created by Samuel Schepp on 14.09.17.
//  Copyright © 2017 Samuel Schepp. All rights reserved.
//

import Foundation
import XCTest
import AugmentedCampusIosCore

class SceneTypeTests: XCTestCase {
	func testRawValue() {
		XCTAssertEqual(SceneType(rawValue: "ARMode")!,		.ARMode);
		XCTAssertEqual(SceneType(rawValue: "NoARMode")!,	.NoARMode);
		XCTAssertEqual(SceneType(rawValue: "fail"),			Optional<SceneType>.none);
		
		
		XCTAssertEqual("ARMode",	SceneType.ARMode.rawValue);
		XCTAssertEqual("NoARMode",	SceneType.NoARMode.rawValue);
	}
}
