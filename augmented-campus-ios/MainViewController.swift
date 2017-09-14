//
//  GameViewController.swift
//  augmented-campus-ios
//
//  Created by Samuel Schepp on 13.09.17.
//  Copyright © 2017 Samuel Schepp. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class MainViewController: UIViewController {

	// MARK: - Outlets
	@IBOutlet weak var sceneView: SCNView!
	
	// MARK: - UIViewController impl
    override func viewDidLoad() {
        super.viewDidLoad()
		
		load(sceneType: .NoARMode)
    }
	
	// MARK: - MainViewController impl
	private func load(sceneType: SceneType) {
		let sceneHandler = SceneHandler.sceneHandlerFactory[sceneType]!()
		sceneView.scene = sceneHandler.scene
		sceneHandler.configure(view: self)
	}
	
	@IBAction func sceneToggleToggled(_ sender: UISwitch) {
		let sceneType = SceneHandler.sceneTypeForToggleState(toggleState: sender.isOn)
		load(sceneType: sceneType)
	}
}

// MARK: - MainViewController config
extension MainViewController {
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return .all
	}
}
