//
//  SceneHandler.swift
//  augmented-campus-ios
//
//  Created by Samuel Schepp on 13.09.17.
//  Copyright © 2017 Samuel Schepp. All rights reserved.
//

import Foundation
import SceneKit

class SceneHandler {
	// MARK: - Class variables
	static let scenesDir = "scn.scnassets/scenes"
	
	// MARK: - Public variables
	var scene: SCNScene? = nil
	
	// MARK: - SceneHandler impl
	init(sceneType: SceneType) {
		let sceneFileName = SceneHandler.getSceneFileName(sceneType: sceneType)
		if let scene = SCNScene(named: sceneFileName, inDirectory: SceneHandler.scenesDir, options: nil) {
			Debugger.log(message: "No-AR Scene loaded: \(sceneType.rawValue)", from: self)
			self.scene = scene;
		}
		else {
			Debugger.log(message: "Error loading No-AR Scene", from: self)
			self.scene = nil
		}
	}
	
	func configure(view: MainViewController) {
		#if DEBUG
		view.sceneView.showsStatistics = true
		#endif
	}
	
	class func getSceneFileName(sceneType: SceneType) -> String {
		return "\(sceneType.rawValue).scn";
	}
	
	static var sceneHandlerFactory: [SceneType: () -> SceneHandler]! {
		get {
			return [
				.NoARMode:	NoARModeSceneHandler.init,
				.ARMode:	ARModeSceneHandler.init,
			]
		}
	}
	
	static func sceneTypeForToggleState(toggleState: Bool) -> SceneType {
		return toggleState ? .NoARMode : .ARMode
	}
}
