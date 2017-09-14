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

class ARModeSceneHandler: SceneHandler, ARSCNViewDelegate {
	private var arSceneView: ARSCNView!
	var mid: CGPoint = CGPoint(x: 0, y: 0)
	
	override func configure(view: ARViewController) {
		super.configure(view: view)
		mid = CGPoint(x: view.arSceneView.bounds.midX, y: view.arSceneView.bounds.midY)
		
		view.sceneView.isHidden = true;
		
		self.arSceneView = view.arSceneView
		view.arSceneView.isHidden = false
		view.arSceneView.scene = SCNScene()
		
		let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
		let config = ARWorldTrackingConfiguration()
		config.planeDetection = .horizontal
		
		view.arSceneView.session.run(config, options: options)
		view.arSceneView.delegate = self
		
		if(ARWorldTrackingConfiguration.isSupported) {
			Debugger.log(message: "Device is supported", from: self)
		}
		else {
			Debugger.log(message: "Device not supported", from: self)
		}
	}
	
	func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
		
	}
	
	func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
		Debugger.log(message: "Renderer did add node", from: self)
		let scene = SCNScene(named: "NoARMode.scn", inDirectory: SceneBasedSceneHandler.scenesDir, options: nil)!
		scene.rootNode.scale = SCNVector3.init(x: 0.0004, y: 0.0004, z: 0.0004)
		scene.rootNode.rotation = SCNVector4(0, 0, 0, 0)
		node.addChildNode(scene.rootNode)
	}
	
	func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
		node.rotation = SCNVector4(0, 0, 0, 0)
	}
	
	func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
		Debugger.log(message: "Renderer did remove node", from: self)
		
		node.childNodes.forEach { child in child.removeFromParentNode() }
	}
	
	func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
		Debugger.log(message: "Camera did change tracking state: \(camera.trackingState)", from: self)
	}
	
	func session(_ session: ARSession, didFailWithError error: Error) {
		Debugger.log(message: "Session did fail with error: \(error.localizedDescription)", from: self)
	}
	
	func sessionWasInterrupted(_ session: ARSession) {
		Debugger.log(message: "Session was interrupted", from: self)
	}
	
	func sessionInterruptionEnded(_ session: ARSession) {
		Debugger.log(message: "Session interruptions ended", from: self)
	}
	
}

extension ARModeSceneHandler {
}
