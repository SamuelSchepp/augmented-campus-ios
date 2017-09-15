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

public class MainViewController: UIViewController {
	
	@IBOutlet weak var arModeStatusLabel: UILabel!
	@IBOutlet weak var arModeARScene: ARSCNView!
	
	private var currentModeHandler: ACModeHandler?
	
	// MARK: - UIViewController impl
	public override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		load(mode: .ARMode)
    }
	
	// MARK: - MainViewController impl
	private func load(mode: ACMode) {
		if(mode == .ARMode) {
			let arModeHandler = ACARModeHandler(delegate: self)
			currentModeHandler = arModeHandler
		}
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

extension MainViewController: ACModeViewDelegate {
	public func sceneViewForHandler(handler: ACModeHandler) -> SCNView {
		return arModeARScene
	}
}

extension MainViewController: ACARModeViewDelegate {
	public func update(status: String, sender: ACARModeHandler) {
		arModeStatusLabel.text = status
	}
}

