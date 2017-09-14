//
//  NoARMode.swift
//  augmented-campus-ios
//
//  Created by Samuel Schepp on 13.09.17.
//  Copyright © 2017 Samuel Schepp. All rights reserved.
//

import Foundation
import SceneKit

class NoARModeSceneHandler: SceneHandler {
	
	// MARK: - SceneHandler impl
	init() {
		super.init(sceneType: .NoARMode)
	}
	
	override func configure(view: MainViewController) {
		super.configure(view: view)
		view.sceneView.allowsCameraControl = true
	}
}
