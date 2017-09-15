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

public class ACARModeHandler: ACModeHandler {
	private var midPointCache: CGPoint?
	private let delegate: ACARModeViewDelegate
	private var campusList: [ARAnchor: SCNNode] = [:]
	
	private let configuration: ARWorldTrackingConfiguration	= { 
		let config = ARWorldTrackingConfiguration() 
		config.planeDetection = .horizontal
		return config
	}()
	
	private let options: ARSession.RunOptions = {
		return [.resetTracking, .removeExistingAnchors]
	}()
	
	public init(delegate: ACARModeViewDelegate) {
		self.delegate = delegate
		
		super.init(delegate: delegate)
		
		if let scene = ACSceneLoader.shared.load(sceneType: .ARScene) {
			arSceneView.scene = scene 
		}
		
		arSceneView.session.run(self.configuration, options: self.options)
		arSceneView.delegate = self
		
		ACDebugger.listener = self
		
		if(ARWorldTrackingConfiguration.isSupported) {
			ACDebugger.log(message: "Device is supported", from: self)
		}
		else {
			ACDebugger.log(message: "Device not supported", from: self)
		}
	}
	
	private var arSceneView: ARSCNView {
		get {
			return delegate.sceneViewForHandler(handler: self) as! ARSCNView
		}
	}
	
	private func getMid() -> CGPoint {
		if let mid = midPointCache {
			return mid
		}
		else {
			let sceneView = arSceneView
			let mid = CGPoint(x: sceneView.bounds.midX, y: sceneView.bounds.midY)
			midPointCache = mid
			return mid
		}
	}
}

extension ACARModeHandler: ACDebuggerDelegate {
	public func updateStatus(message: String) {
		delegate.update(status: message, sender: self)
	}
}

extension ACARModeHandler {
	
	private func addCampusForAnchor(anchor: ARPlaneAnchor) {
		guard
			let scene = delegate.sceneViewForHandler(handler: self).scene, 
			let campusScene = ACSceneLoader.shared.load(sceneType: .campus0)
			else {
			ACDebugger.log(message: "Error adding campus", from: self)
			return
		}
		
		let campusNode = campusScene.rootNode
		campusNode.name = ACSceneType.campus0.rawValue
		campusNode.simdScale 	= float3(x: 0.0005, y: 0.0005, z: 0.0005)
		campusNode.simdPosition = float3(anchor.center.x, 0, anchor.center.z)
		campusNode.simdRotation = float4(0, 0, 0, 0)
		if let floor = campusNode.childNode(withName: "floor", recursively: true) {
			floor.geometry?.firstMaterial?.writesToDepthBuffer = false
			floor.geometry?.firstMaterial?.colorBufferWriteMask = []
		}
		
		scene.rootNode.addChildNode(campusNode)
		
		self.campusList[anchor] = campusNode
	}
	
	private func updateCampusForAnchor(anchor: ARPlaneAnchor, andNode node: SCNNode) {
		self.campusList[anchor]?.position = node.convertPosition(SCNVector3(0, 0, 0), to: arSceneView.scene.rootNode)
	}
	
	private func removeCampusForAnchor(anchor: ARPlaneAnchor) {
		self.campusList.removeValue(forKey: anchor)
	}
}

extension ACARModeHandler: ARSCNViewDelegate {
	public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
		
	}
	
	public func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
		ACDebugger.log(message: "Renderer did add node", from: self)
		
		guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
		let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
		let planeNode = SCNNode(geometry: plane)
		planeNode.simdPosition = float3(planeAnchor.center.x, 0, planeAnchor.center.z)
		planeNode.eulerAngles.x = -.pi / 2
		planeNode.opacity = 0.05
		node.addChildNode(planeNode)
		
		addCampusForAnchor(anchor: planeAnchor)
	}
	
	public func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
		guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
		
		if let planeNode = node.childNodes.first, let plane = planeNode.geometry as? SCNPlane { 
			planeNode.simdPosition = float3(planeAnchor.center.x, 0, planeAnchor.center.z)
			plane.width = CGFloat(planeAnchor.extent.x)
			plane.height = CGFloat(planeAnchor.extent.z)
		}
		
		updateCampusForAnchor(anchor: planeAnchor, andNode: node)
	}
	
	public func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
		ACDebugger.log(message: "Renderer did remove node", from: self)
		
		guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
		removeCampusForAnchor(anchor: planeAnchor)
	}
	
	public func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
		ACDebugger.log(message: "Camera did change tracking state: \(camera.trackingState)", from: self)
	}
	
	public func session(_ session: ARSession, didFailWithError error: Error) {
		ACDebugger.log(message: "Session did fail with error: \(error.localizedDescription)", from: self)
	}
	
	public func sessionWasInterrupted(_ session: ARSession) {
		ACDebugger.log(message: "Session was interrupted", from: self)
	}
	
	public func sessionInterruptionEnded(_ session: ARSession) {
		ACDebugger.log(message: "Session interruptions ended", from: self)
	}
}