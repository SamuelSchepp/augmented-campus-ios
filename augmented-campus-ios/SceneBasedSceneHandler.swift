//
//  SceneBasedSceneHandler.swift
//  augmented-campus-ios
//
//  Created by Samuel Schepp on 14.09.17.
//  Copyright © 2017 Samuel Schepp. All rights reserved.
//

import Foundation
import SceneKit

public class SceneBasedSceneHandler: SceneHandler {
	// MARK: - Class variables
	public static let scenesDir = "scn.scnassets/scenes"
	
	// MARK: - Public variables
	public var scene: SCNScene? = nil
	
	// MARK: - SceneHandler impl
	init(sceneType: SceneType) {
		super.init()
		
		let sceneFileName = SceneBasedSceneHandler.getSceneFileName(sceneType: sceneType)
		if let scene = SCNScene(named: sceneFileName, inDirectory: SceneBasedSceneHandler.scenesDir, options: nil) {
			Debugger.log(message: "No-AR Scene loaded: \(sceneType.rawValue)", from: self)
			self.scene = scene;
		}
		else {
			Debugger.log(message: "Error loading No-AR Scene", from: self)
			self.scene = nil
		}
	}
	
	public class func getSceneFileName(sceneType: SceneType) -> String {
		return "\(sceneType.rawValue).scn";
	}
	
	public override func configure(view: ARViewController) {
		view.sceneView.scene = scene
		super.configure(view: view)
	}
}
