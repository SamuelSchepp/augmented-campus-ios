//
//  NoARModeSceneHandlerTests.swift
//  augmented-campus-ios
//
//  Created by Samuel Schepp on 14.09.17.
//  Copyright © 2017 Samuel Schepp. All rights reserved.
//

import Foundation
import XCTest

class GenericSceneHandlerTests: XCTestCase {
	func testNoARMode() {
		let handler = SceneHandler.sceneHandlerFactory[.NoARMode]!()
		XCTAssertNotNil(handler.scene)
	}
	
	func testARMode() {
		let handler = SceneHandler.sceneHandlerFactory[.ARMode]!()
		XCTAssertNil(handler.scene)
	}
	
	func testSceneFileName() {
		XCTAssertEqual(SceneHandler.getSceneFileName(sceneType: .NoARMode), "NoARMode.scn")
		XCTAssertEqual(SceneHandler.getSceneFileName(sceneType: .ARMode), "ARMode.scn")
	}
	
	func testScenesDir() {
		XCTAssertEqual(SceneHandler.scenesDir, "scn.scnassets/scenes")
	}
	
	func testToggleState() {
		XCTAssertEqual(SceneHandler.sceneTypeForToggleState(toggleState: true), .NoARMode)
		XCTAssertEqual(SceneHandler.sceneTypeForToggleState(toggleState: false), .ARMode)
	}
}
