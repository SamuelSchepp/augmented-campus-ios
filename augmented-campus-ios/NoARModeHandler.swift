//
//  NoARMode.swift
//  augmented-campus-ios
//
//  Created by Samuel Schepp on 13.09.17.
//  Copyright © 2017 Samuel Schepp. All rights reserved.
//

import Foundation
import SceneKit

class NoARModeSceneHandler: SceneBasedSceneHandler {
	
	// MARK: - SceneHandler impl
	init() {
		super.init(sceneType: .NoARMode)
	}
	
	override func configure(view: ARViewController) {
		super.configure(view: view)
		view.arSceneView.isHidden = true
		view.sceneView.isHidden = false;
		view.sceneView.scene = self.scene!
		view.sceneView.allowsCameraControl = true
	}
}
