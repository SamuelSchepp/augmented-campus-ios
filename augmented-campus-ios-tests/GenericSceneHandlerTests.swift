//
//  NoARModeSceneHandlerTests.swift
//  augmented-campus-ios
//
//  Created by Samuel Schepp on 14.09.17.
//  Copyright © 2017 Samuel Schepp. All rights reserved.
//

import Foundation
import XCTest
import AugmentedCampusIosCore

class GenericSceneHandlerTests: XCTestCase {
	func testNoARMode() {
		let handler = SceneBasedSceneHandler.sceneHandlerFactory[.NoARMode]!()
		XCTAssertNotNil((handler as! SceneBasedSceneHandler).scene)
	}
	
	func testSceneFileName() {
		XCTAssertEqual(SceneBasedSceneHandler.getSceneFileName(sceneType: .NoARMode), "NoARMode.scn")
		XCTAssertEqual(SceneBasedSceneHandler.getSceneFileName(sceneType: .ARMode), "ARMode.scn")
	}
	
	func testScenesDir() {
		XCTAssertEqual(SceneBasedSceneHandler.scenesDir, "scn.scnassets/scenes")
	}
	
	func testToggleState() {
		XCTAssertEqual(SceneHandler.sceneTypeForToggleState(toggleState: true), .NoARMode)
		XCTAssertEqual(SceneHandler.sceneTypeForToggleState(toggleState: false), .ARMode)
	}
}
