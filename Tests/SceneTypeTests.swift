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
		XCTAssertEqual(ACSceneType(rawValue: "ARScene"),	.ARScene);
		XCTAssertEqual(ACSceneType(rawValue: "NoARScene"),	.NoARScene);
		XCTAssertEqual(ACSceneType(rawValue: "campus0"),	.campus0);
		XCTAssertEqual(ACSceneType(rawValue: "fail"),		ACSceneType?.none);
		
		
		XCTAssertEqual("ARScene",	ACSceneType.ARScene.rawValue);
		XCTAssertEqual("NoARScene",	ACSceneType.NoARScene.rawValue);
		XCTAssertEqual("campus0",	ACSceneType.campus0.rawValue);
	}
}
