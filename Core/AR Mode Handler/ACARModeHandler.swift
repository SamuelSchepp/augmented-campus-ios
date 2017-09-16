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
	private var midPointCache: 	CGPoint?
	private let delegate: 		ACARModeViewDelegate
	private var campusList: 	[ARAnchor: SCNNode] = [:]
	private var airCampusList: 	[SCNNode] 			= []
	private var targetPlane:	SCNNode				= ACFactory.shared.targetPlane()
	private var currentTargetPlaneAnchor: ARPlaneAnchor?
	
	#if DEBUG
	private var featureNodes: 	[SCNNode] 			= []
	#endif
	
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
		
		arSceneView.scene.rootNode.addChildNode(targetPlane)
		arSceneView.session.run(self.configuration, options: self.options)
		arSceneView.delegate = self
		
		#if DEBUG
			arSceneView.showsStatistics = true
		#endif
		
		arSceneView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
		arSceneView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longTap)))
		
		ACDebugger.listener = self
		
		if(ARWorldTrackingConfiguration.isSupported) {
			ACDebugger.log(message: "Device is supported", from: self)
		}
		else {
			ACDebugger.log(message: "Device not supported", from: self)
		}
	}
	
	@objc public func tap() {
		ACDebugger.log(message: "Tapped", from: self)
		
		var campus: SCNNode = SCNNode()
		
		if let anchor = currentTargetPlaneAnchor {
			// Place campus on plane
			
			if let currentCampus = campusList[anchor] {
				currentCampus.removeFromParentNode()
			}
			campus = ACFactory.shared.campus0(invisibleFloor: true)
			campus.simdWorldTransform = targetPlane.simdWorldTransform
			campusList[anchor] = campus
		}
		else {
			// Place campus in air
			
			campus = ACFactory.shared.campus0(invisibleFloor: false)
			
			var translation = matrix_identity_float4x4
			translation.columns.3.z = -0.5
			
			campus.simdTransform = matrix_multiply(camera.transform, translation)
			airCampusList.append(campus)
		}
		
		campus.eulerAngles = SCNVector3(0, camera.eulerAngles.y, 0)
		campus.simdScale = ACFactory.shared.campus0Scale
		arSceneView.scene.rootNode.addChildNode(campus)
	}
	
	@objc public func longTap() {
		campusList.forEach { (anchor, campus) in
			campus.removeFromParentNode()
		}
		
		airCampusList.forEach { (node) in
			node.removeFromParentNode()
		}
		
		campusList = [:]
		airCampusList = []
	}
	
	public override func deviceRotated() {
		super.deviceRotated()
		midPointCache = nil;
	}
	
	private var arSceneView: ARSCNView {
		get {
			return delegate.sceneViewForHandler(handler: self) as! ARSCNView
		}
	}
	
	private var mid: CGPoint {
		get {
			if let _mid = midPointCache {
				return _mid
			}
			else {
				let sceneView = arSceneView
				var _mid: CGPoint = CGPoint(x: 0, y: 0)
				DispatchQueue.main.sync {
					_mid = CGPoint(x: sceneView.bounds.midX, y: sceneView.bounds.midY)
				}
				midPointCache = _mid
				return _mid
			}
		}
	}
	
	private var camera: ARCamera {
		get {
			return arSceneView.session.currentFrame!.camera
		}
	}
}

extension ACARModeHandler: ACDebuggerDelegate {
	public func updateStatus(message: String) {
		delegate.update(status: message, sender: self)
	}
}

extension ACARModeHandler: ARSCNViewDelegate {
	public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
		/*
			Render feature points
		*/
		#if DEBUG
		guard let points = arSceneView.session.currentFrame?.rawFeaturePoints?.points else { return }
		for i in 0..<points.count {
			if i < featureNodes.count {
				featureNodes[i].position = SCNVector3.init(points[i].x, points[i].y, points[i].z)
			}
			else {
				let node = ACFactory.shared.featurePointForPoint(points[i])
				featureNodes.append(node)
				arSceneView.scene.rootNode.addChildNode(node)
			}
		}
		
		for _ in points.count..<featureNodes.count {
			featureNodes.last!.removeFromParentNode()
			featureNodes.removeLast()
		}
		#endif
		
		/*
			Hittest planes for rendering the target plane
		*/
		let planeHitTestResults = arSceneView.hitTest(self.mid, types: .existingPlaneUsingExtent)
		if let result = planeHitTestResults.first {
			targetPlane.simdWorldTransform = result.worldTransform
			targetPlane.eulerAngles = SCNVector3(-Float.pi / 2, camera.eulerAngles.y, 0)
			currentTargetPlaneAnchor = result.anchor as? ARPlaneAnchor
			if campusList[currentTargetPlaneAnchor!] == nil {
				targetPlane.isHidden = false
			}
			else {
				targetPlane.isHidden = true
			}
		}
		else {
			targetPlane.isHidden = true
			currentTargetPlaneAnchor = nil
		}
	}
	
	public func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
		ACDebugger.log(message: "Renderer did add node", from: self)
		
		/*
			Add plane, which represents the surface
		*/
		guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
		let plane = ACFactory.shared.planeForSize(
			CGSize(
				width: 	CGFloat(planeAnchor.extent.x),
				height: CGFloat(planeAnchor.extent.z)
			)
		)
		node.addChildNode(plane)
	}
	
	public func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
		guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
		
		/*
			Update the planes size
		*/
		if let planeNode = node.childNodes.first, let plane = planeNode.geometry as? SCNPlane { 
			plane.width = CGFloat(planeAnchor.extent.x)
			plane.height = CGFloat(planeAnchor.extent.z)
		}
		
		/*
			Update y of campus
		*/
		SCNTransaction.animationDuration = 1.0
		self.campusList[anchor]?.position.y = node.position.y
	}
	
	public func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
		ACDebugger.log(message: "Renderer did remove node", from: self)
		guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
		
		/*
			Remove child nodes of anchor node, which should contain the plane
		*/
		node.childNodes.forEach({ child in child.removeFromParentNode() })
		
		/*
			Remove campus model, that is based on the anchor
		*/
		campusList.removeValue(forKey: planeAnchor)?.removeFromParentNode()
	}
	
	public func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
		ACDebugger.log(message: "Camera did change tracking state: \(camera.trackingState)", from: self)
		switch camera.trackingState {
		case .normal:
			delegate.updateStatusOK(ok: true, sender: self)
			break
		default:
			delegate.updateStatusOK(ok: false, sender: self)
			
		}
	}
	
	public func session(_ session: ARSession, didFailWithError error: Error) {
		delegate.updateStatusOK(ok: false, sender: self)
		ACDebugger.log(message: "Session did fail with error: \(error.localizedDescription)", from: self)
	}
	
	public func sessionWasInterrupted(_ session: ARSession) {
		delegate.updateStatusOK(ok: false, sender: self)
		ACDebugger.log(message: "Session was interrupted", from: self)
	}
	
	public func sessionInterruptionEnded(_ session: ARSession) {
		delegate.updateStatusOK(ok: true, sender: self)
		ACDebugger.log(message: "Session interruptions ended", from: self)
	}
}
