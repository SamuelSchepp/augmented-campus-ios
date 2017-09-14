//
//  Debugger.swift
//  augmented-campus-ios
//
//  Created by Samuel Schepp on 13.09.17.
//  Copyright © 2017 Samuel Schepp. All rights reserved.
//

import Foundation

class Debugger {
	private static var _lines: [String] = [];
	
	class func log(message: String, from sender: Any) {
		#if DEBUG
			let compMessage = "[\(type(of: sender))] \(message)"
			_lines.append(compMessage)
			print(compMessage);
		#endif
	}
	
	class var lines: String {
		get {
			return _lines.joined(separator: "\n")
		}
	}
	
	class func reset() {
		_lines = []
	}
}
