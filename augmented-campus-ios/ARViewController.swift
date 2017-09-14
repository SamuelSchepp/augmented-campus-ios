//
//  ARViewController.swift
//  AugmentedCampusIosCore
//
//  Created by Samuel Schepp on 14.09.17.
//  Copyright © 2017 Samuel Schepp. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

public protocol ARViewController {
	weak var sceneView: SCNView! { get }
	weak var arSceneView: ARSCNView! { get }
}
