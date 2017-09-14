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
import ARKit
import AugmentedCampusIosCore

public class MainViewController: UIViewController, ARViewController, DebuggerUIListener {

	// MARK: - Outlets
	@IBOutlet public weak var arSceneView: ARSCNView!
	@IBOutlet public weak var sceneView: SCNView!
	@IBOutlet weak var statusText: UILabel!
	
	private var currentSceneHandler: SceneHandler!
	
	// MARK: - UIViewController impl
	public override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		Debugger.listener = self
		load(sceneType: .ARMode)
    }
	
	// MARK: - MainViewController impl
	private func load(sceneType: SceneType) {
		let sceneHandler = SceneHandler.sceneHandlerFactory[sceneType]!()
		sceneHandler.configure(view: self)
		currentSceneHandler = sceneHandler
	}
	
	@IBAction func sceneToggleToggled(_ sender: UISwitch) {
		let sceneType = SceneHandler.sceneTypeForToggleState(toggleState: sender.isOn)
		load(sceneType: sceneType)
	}
}

// MARK: - MainViewController config
extension MainViewController {
	public override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return .all
	}
}

extension MainViewController {
	public func updateStatus(message: String) {
		statusText.text = message
	}
}
