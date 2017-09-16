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
				floor.opacity = 0.00001
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
		/*      
				n0
		        --
			n3 |  | n1
			    --
			    n2
		*/
		
		let container 		= SCNNode()
		let lineSpacing		= CGFloat(0.1)
		let lineThicknes 	= CGFloat(0.01)
		let width 			= CGFloat(1000.0 * campus0Scale.x)
		let height 			= CGFloat(666.666 * campus0Scale.y)
		let opacity			= CGFloat(0.5)
		
		var nodes = [SCNNode]()
		for _ in 0...3 {
			let plane = SCNPlane()
			plane.cornerRadius = 0.003
			plane.firstMaterial?.diffuse.contents = SKColor.green
			
			let node = SCNNode(geometry: plane)
			node.castsShadow 	= false
			node.name			= "target"
			node.opacity		= opacity
			
			nodes.append(node)
			container.addChildNode(node)
		}
		
		(nodes[0].geometry as! SCNPlane).width = width - lineSpacing
		(nodes[1].geometry as! SCNPlane).width = lineThicknes
		(nodes[2].geometry as! SCNPlane).width = width - lineSpacing
		(nodes[3].geometry as! SCNPlane).width = lineThicknes
		
		(nodes[0].geometry as! SCNPlane).height = lineThicknes
		(nodes[1].geometry as! SCNPlane).height = height - lineSpacing
		(nodes[2].geometry as! SCNPlane).height = lineThicknes
		(nodes[3].geometry as! SCNPlane).height = height - lineSpacing
		
		nodes[0].position = SCNVector3(0, height / 2, 0)
		nodes[1].position = SCNVector3(width / 2, 0, 0)
		nodes[2].position = SCNVector3(0, -height / 2, 0)
		nodes[3].position = SCNVector3(-width / 2, 0, 0)
		
		let circleGeometry = SCNPlane(width: lineThicknes * 2, height: lineThicknes * 2)
		circleGeometry.cornerRadius = lineThicknes
		circleGeometry.firstMaterial?.diffuse.contents = SKColor.green
		let circle = SCNNode(geometry: circleGeometry)
		circle.opacity 		= opacity
		circle.castsShadow 	= false
		
		container.addChildNode(circle)
		
		return container
	}
}
