//
//  DebuggerTests.swift
//  augmented-campus-ios
//
//  Created by Samuel Schepp on 14.09.17.
//  Copyright © 2017 Samuel Schepp. All rights reserved.
//

import Foundation
import XCTest
import AugmentedCampusIosCore

class DebuggerTests: XCTestCase {
	func testLines() {
		ACDebugger.log(message: "init", from: self)
		ACDebugger.reset()
		
		ACDebugger.log(message: "test1", from: self)
		ACDebugger.log(message: "test2", from: self)
		ACDebugger.log(message: "test3", from: self)
		
		XCTAssertEqual("[DebuggerTests] test1\n[DebuggerTests] test2\n[DebuggerTests] test3", ACDebugger.lines)
	}
}
