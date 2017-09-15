//
//  Debugger.swift
//  augmented-campus-ios
//
//  Created by Samuel Schepp on 13.09.17.
//  Copyright © 2017 Samuel Schepp. All rights reserved.
//

import Foundation

public class ACDebugger {
	private static var _lines: [String] = [];
	public static var listener: ACDebuggerDelegate?
	
	public class func log(message: String, from sender: Any) {
		let compMessage = "[\(type(of: sender))] \(message)"
		
		#if DEBUG
			_lines.append(compMessage)
			print(compMessage);
		#endif
		
		if let listener = listener {
			DispatchQueue.main.async {
				listener.updateStatus(message: compMessage)
			}
		}
	}
	
	public class var lines: String {
		get {
			return _lines.joined(separator: "\n")
		}
	}
	
	public class func reset() {
		_lines = []
	}
}

public protocol ACDebuggerDelegate {
	func updateStatus(message: String)
}
