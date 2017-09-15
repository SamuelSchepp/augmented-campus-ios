//
//  ACARModeViewDelegate.swift
//  AugmentedCampusIosCore
//
//  Created by Samuel Schepp on 15.09.17.
//  Copyright © 2017 Samuel Schepp. All rights reserved.
//

import Foundation
import ARKit
import SceneKit

public protocol ACARModeViewDelegate: ACModeViewDelegate {
	func update(status: String, sender: ACARModeHandler)
}
