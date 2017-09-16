//
//  ACFactory.swift
//  AugmentedCampusIosCore
//
//  Created by Samuel Schepp on 16.09.17.
//  Copyright © 2017 Samuel Schepp. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

public class ACFactory: NSObject {
	private static var _shared: ACFactory?
	public static var shared: ACFactory {
		get {
			if let instance = _shared {
				return instance
			}
			else {
				let instance = ACFactory()
				_shared = instance
				return instance
			}
		}
	}
	
	public var campus0Scale: float3 {
		get {
			return float3(x: 0.0005, y: 0.0005, z: 0.0005)
		}
	}
	
	public func planeForSize(_ size: CGSize) -> SCNNode {
		let plane 				= SCNPlane(width: CGFloat(size.width), height: CGFloat(size.height))
		let planeNode 			= SCNNode(geometry: plane)
		plane.cornerRadius 		= 0.005
		planeNode.name			= "anchor plane"
		planeNode.eulerAngles.x = -.pi / 2
		planeNode.opacity 		= 0
		return planeNode
	}
	
	public func campus0(invisibleFloor: Bool) -> SCNNode {
		guard let campusScene 		= ACSceneLoader.shared.load(sceneType: .campus0) else {
			return SCNNode()
		}
		let campusNode 			= campusScene.rootNode
		campusNode.name 		= ACSceneType.campus0.rawValue
		campusNode.simdScale 	= campus0Scale
		
		if invisibleFloor {
			if let floor = campusNode.childNode(withName: "floor", recursively: true) {
				floor.geometry?.firstMaterial?.diffuse.contents = UIColor.white
				floor.geometry?.firstMaterial?.colorBufferWriteMask = SCNColorMask(rawValue: 0)
				floor.geometry?.firstMaterial?.writesToDepthBuffer = false
			}
		}
		
		return campusNode
	}
	
	public func featurePointForPoint(_ point: vector_float3) -> SCNNode {
		let node = SCNNode(geometry: SCNSphere(radius: 0.001))
		
		node.geometry?.firstMaterial?.diffuse.contents = SKColor.magenta
		node.name 			= "feature"
		node.castsShadow 	= false
		node.position 		= SCNVector3(point.x, point.y, point.z)
		
		return node
	}
	
	public func targetPlane() -> SCNNode {
		let plane 				= SCNPlane(width: CGFloat(1000.0 * campus0Scale.x), height: CGFloat(666.666 * campus0Scale.y))
		let planeNode 			= SCNNode(geometry: plane)
		plane.cornerRadius 		= 0.001
		plane.firstMaterial?.diffuse.contents = SKColor.white
		planeNode.castsShadow 	= false
		planeNode.name			= "target plane"
		planeNode.opacity 		= 0.5
		planeNode.isHidden 		= true
		
		return planeNode
	}
}
