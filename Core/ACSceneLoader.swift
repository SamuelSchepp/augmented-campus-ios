//
//  ACSceneLoader.swift
//  AugmentedCampusIosCore
//
//  Created by Samuel Schepp on 15.09.17.
//  Copyright © 2017 Samuel Schepp. All rights reserved.
//

import Foundation
import SceneKit

public class ACSceneLoader {
	private static var _shared: ACSceneLoader?
	public static var shared: ACSceneLoader {
		get {
			if let instance = _shared {
				return instance
			}
			else {
				let instance = ACSceneLoader()
				_shared = instance
				return instance
			}
		}
	}
	
	public let scenesDir = "scn.scnassets/scenes"
	
	public func load(sceneType: ACSceneType) -> SCNScene? {
		let sceneName = sceneType.rawValue
		let bundle = Bundle(for: type(of: self))
		guard let url = bundle.url(forResource: sceneName, withExtension: "scn", subdirectory: scenesDir) else {
			return SCNScene?.none
		}
		
		do {
			let scene = try SCNScene.init(url: url, options: nil)
			ACDebugger.log(message: "Scene loaded: \(sceneName)", from: self)
			return scene
		}
		catch {
			ACDebugger.log(message: "Error loading \(sceneName)", from: self)
			return SCNScene?.none
		}
		
	}
}
