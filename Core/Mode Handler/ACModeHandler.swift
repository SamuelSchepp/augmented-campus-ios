//
//  SceneHandler.swift
//  augmented-campus-ios
//
//  Created by Samuel Schepp on 13.09.17.
//  Copyright © 2017 Samuel Schepp. All rights reserved.
//

import Foundation
import SceneKit

public class ACModeHandler: NSObject {
	private var delegate: ACModeViewDelegate
	
	init(delegate: ACModeViewDelegate) {
		self.delegate = delegate
		
		super.init()
	}
}
