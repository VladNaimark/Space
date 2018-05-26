//
//  SCNNode+ext.swift
//  Space
//
//  Created by Vladislav Naimark on 4/27/18.
//  Copyright © 2018 Vladislav Naimark. All rights reserved.
//

import Foundation
import SceneKit

extension SCNNode {
    
    func rotateNode(aroundPoint: SCNVector3, rotation: SCNVector4) {
        let position = self.position
        self.position = aroundPoint
        self.rotation = rotation
        self.position = position
    }
}
