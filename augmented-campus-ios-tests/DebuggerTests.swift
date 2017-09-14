//
//  DebuggerTests.swift
//  augmented-campus-ios
//
//  Created by Samuel Schepp on 14.09.17.
//  Copyright © 2017 Samuel Schepp. All rights reserved.
//

import Foundation
import XCTest

class DebuggerTests: XCTestCase {
	func testLines() {
		Debugger.log(message: "init", from: self)
		Debugger.reset()
		
		Debugger.log(message: "test1", from: self)
		Debugger.log(message: "test2", from: self)
		Debugger.log(message: "test3", from: self)
		
		XCTAssertEqual("[DebuggerTests] test1\n[DebuggerTests] test2\n[DebuggerTests] test3", Debugger.lines)
	}
}
