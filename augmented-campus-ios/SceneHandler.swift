//
//  SceneHandler.swift
//  augmented-campus-ios
//
//  Created by Samuel Schepp on 13.09.17.
//  Copyright © 2017 Samuel Schepp. All rights reserved.
//

import Foundation
import SceneKit

public class SceneHandler {
	public func configure(view: ARViewController) {
		#if DEBUG
		view.arSceneView.showsStatistics = true
		#endif
	}
	
	public static var sceneHandlerFactory: [SceneType: () -> SceneHandler]! {
		get {
			return [
				.NoARMode:	NoARModeSceneHandler.init,
				.ARMode:	ARModeSceneHandler.init,
			]
		}
	}
	
	public static func sceneTypeForToggleState(toggleState: Bool) -> SceneType {
		return toggleState ? .NoARMode : .ARMode
	}
}
