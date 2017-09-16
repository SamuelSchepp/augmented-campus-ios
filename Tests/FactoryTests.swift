//
//  FactoryTests.swift
//  AugmentedCampusIosTests
//
//  Created by Samuel Schepp on 16.09.17.
//  Copyright © 2017 Samuel Schepp. All rights reserved.
//

import Foundation
import XCTest
import AugmentedCampusIosCore
import SceneKit
import ARKit

class FactoryTests: XCTestCase {
	func testShared() {
		XCTAssertNotNil(ACFactory.shared)
	}
	
	func testCampus0Scale() {
		XCTAssertEqual(ACFactory.shared.campus0Scale, float3(x: 0.0005, y: 0.0005, z: 0.0005))
	}
	
	func testPlaneForSize() {
		let plane: SCNNode = ACFactory.shared.planeForSize(CGSize(width: 10, height: 20))
		XCTAssertEqual(plane.name, "anchor plane")
		XCTAssertEqual((plane.geometry as! SCNPlane).width, 10)
		XCTAssertEqual((plane.geometry as! SCNPlane).height, 20) 
	}
	
	func testCampus0() {
		let campus: SCNNode = ACFactory.shared.campus0(invisibleFloor: false)
		XCTAssertEqual(campus.name, "campus0")
		XCTAssertEqual(campus.simdScale, float3(x: 0.0005, y: 0.0005, z: 0.0005))
	}
	
	func testfeaturePointForPoint() {
		let point: SCNNode = ACFactory.shared.featurePointForPoint(vector_float3(1, 2, 3))
		XCTAssertEqual(point.name, "feature")
		XCTAssertEqual(point.simdPosition, float3(1, 2, 3))
	}
}
