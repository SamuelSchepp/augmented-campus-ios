//
//  SceneLoaderTests.swift
//  AugmentedCampusIosTests
//
//  Created by Samuel Schepp on 15.09.17.
//  Copyright © 2017 Samuel Schepp. All rights reserved.
//

import Foundation
import XCTest
import AugmentedCampusIosCore

class SceneLoaderTests: XCTestCase {
	func testNoARMode() {
		let scene = ACSceneLoader.shared.load(sceneType: .NoARScene)
		XCTAssertNotNil(scene)
	}
	
	func testARMode() {
		let scene = ACSceneLoader.shared.load(sceneType: .ARScene)
		XCTAssertNotNil(scene)
	}
	
	func testCampus0() {
		let scene = ACSceneLoader.shared.load(sceneType: .campus0)
		XCTAssertNotNil(scene)
	}
}
