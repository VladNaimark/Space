//
//  GameViewController.swift
//  Space
//
//  Created by Vladislav Naimark on 4/25/18.
//  Copyright © 2018 Vladislav Naimark. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    
    var rocket: SCNNode!
    var startPanel: SCNNode!
    var lastPanDate: Date?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var scene = SCNScene(named: "StartPanel.scn")!
        startPanel = scene.rootNode.childNode(withName: "StartPanel", recursively: true)!
        startPanel.position = SCNVector3(x: 0, y: 10, z: 0)
        startPanel.scale = SCNVector3(x: 0.25, y: 0.25, z: 0.25)
        
        scene = SCNScene(named: "rocketship.scn")!
        rocket = scene.rootNode.childNode(withName: "rocketship", recursively: true)!
        startPanel.addChildNode(rocket)
        
//        startPanel.simdRotate(by: simd_quatf(angle: .pi/4.0, axis: float3(x: 1, y: 0, z: 0)), aroundTarget: simd_float3(x: 0, y: 0, z: 0) )
        
        // create a new scene
        scene = SCNScene(named: "MainScene.scn")!
        scene.rootNode.addChildNode(startPanel)
        
//        rocket.simdRotate(by: simd_quatf(angle: .pi/4.0, axis: float3(x: 1, y: 0, z: 0)), aroundTarget: simd_float3(x: 10, y: 0, z: 0) )
//        rocket.simdRotate(by: SCNQuaternion(x: 1, y: 0, z: 0, w: .pi / 4), aroundTarget: SCNVector3Zero)
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor(red: 1, green: 1, blue: 0.7, alpha: 0.001)
        scene.rootNode.addChildNode(ambientLightNode)
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        scnView.delegate = self
        
        // allows the user to manipulate the camera
//        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.black
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    @IBAction func pan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        if sender.state == .changed {
            lastPanDate = Date()
            var rotation = startPanel.simdRotation
            var zAngle = Float(-translation.x / 360.0 * .pi)
            if rotation.z * rotation.w + zAngle < 0 {
                zAngle = -(rotation.z * rotation.w)
            } else if rotation.z * rotation.w + zAngle > .pi / 4 {
                zAngle = .pi / 4 - rotation.z * rotation.w
            }
            var xAngle = Float(translation.y / 360.0 * .pi)
//            if rotation.x * rotation.w + xAngle < 0 {
//                xAngle = 0
//            } else if rotation.x * rotation.w + xAngle > .pi / 4 {
//                xAngle = .pi / 2
//            }
            
            startPanel.simdRotate(by: simd_quatf(angle: zAngle,
                                axis: float3(x: 0, y: 0, z: 1)),
                        aroundTarget: simd_float3() )
//            startPanel.simdRotate(by: simd_quatf(angle: xAngle,
//                                axis: float3(x: 1, y: 0, z: 0)),
//                        aroundTarget: simd_float3() )
            print("\(startPanel.simdRotation)")
        } else if sender.state == .ended {
//            let duration : CGFloat = 0.1
//            var velocity = sender.velocity(in: self.view)
//            if let panDate = lastPanDate, -panDate.timeIntervalSinceNow > 0.25 {
//                velocity = CGPoint(x: 0, y: 0)
//            }
//            let endPoint = CGPoint(x: velocity.x * duration, y: velocity.y * duration)
//            if endPoint.x != 0 && endPoint.y != 0 {
//
//                SCNTransaction.begin()
//                SCNTransaction.animationDuration = 2
//
//                startPanel.simdRotate(by: simd_quatf(angle: Float(-endPoint.x / 360.0 * .pi),
//                                                     axis: float3(x: 0, y: 0, z: 1)),
//                                      aroundTarget: simd_float3() )
//                startPanel.simdRotate(by: simd_quatf(angle: Float(endPoint.y / 360.0 * .pi),
//                                                     axis: float3(x: 1, y: 0, z: 0)),
//                                      aroundTarget: simd_float3() )
//
//                SCNTransaction.commit()
//            }
        }
        sender.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
    }
}

extension GameViewController : SCNSceneRendererDelegate {
    
}
