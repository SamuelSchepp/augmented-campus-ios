//
//  ARModeHandler.swift
//  augmented-campus-ios
//
//  Created by Samuel Schepp on 14.09.17.
//  Copyright © 2017 Samuel Schepp. All rights reserved.
//

import Foundation
import SceneKit

class ARModeSceneHandler: SceneHandler {
	
	// MARK: - SceneHandler impl
	init() {
		super.init(sceneType: .ARMode)
	}
	
	override func configure(view: MainViewController) {
		super.configure(view: view)
	}
}
