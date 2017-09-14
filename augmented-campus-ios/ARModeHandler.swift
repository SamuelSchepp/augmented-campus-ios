//
//  ARModeHandler.swift
//  augmented-campus-ios
//
//  Created by Samuel Schepp on 14.09.17.
//  Copyright © 2017 Samuel Schepp. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class ARModeSceneHandler: SceneHandler {
	
	override func configure(view: ARViewController) {
		super.configure(view: view)
		view.arSceneView.isHidden = false
		view.sceneView.isHidden = true;
		
		let arHandler = ARViewHandler()
		let config = ARWorldTrackingConfiguration()
		config.worldAlignment = ARConfiguration.WorldAlignment.gravityAndHeading
		
		view.arSceneView.delegate = arHandler
		view.arSceneView.session.run(config)
		
		if(ARWorldTrackingConfiguration.isSupported) {
			Debugger.log(message: "Device is supported", from: self)
		}
		else {
			
			Debugger.log(message: "Device not supported", from: self)
		}
	}
}

class ARViewHandler: NSObject, ARSCNViewDelegate {
	func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
		Debugger.log(message: "Renderer did add node", from: self)
	}
	
	func renderer(_ renderer: SCNSceneRenderer, willUpdate node: SCNNode, for anchor: ARAnchor) {
		Debugger.log(message: "Renderer will update node", from: self)
	}
	
	func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
		Debugger.log(message: "Renderer did remove node", from: self)
	}
}
