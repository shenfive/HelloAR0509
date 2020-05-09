//
//  ViewController.swift
//  HelloAR0509
//
//  Created by 申潤五 on 2020/5/9.
//  Copyright © 2020 申潤五. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        
        let scene = SCNScene() //使用空白場景
        
        // Set the scene to the view
        sceneView.scene = scene
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01) //新增一個 BOX
        let material = SCNMaterial() //新增材質
        material.diffuse.contents = UIColor.red  //材質內容為紅色
        box.materials = [material] //把 box 的貼圖材質加進去
        let node = SCNNode(geometry: box) //新增一個 Box
        node.position = SCNVector3(0, 0, -0.5) //設定 node 在空間的位置
        sceneView.scene.rootNode.addChildNode(node) //把 node 加入到目前的 scene 上
        
        
        let text = SCNText(string: "Hello Text in AR", extrusionDepth: 1.0)
        text.firstMaterial?.diffuse.contents = UIColor.blue
        
        let textNode = SCNNode(geometry: text)
        textNode.position = SCNVector3(0, 0.05, -0.5)
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        
        sceneView.scene.rootNode.addChildNode(textNode)
        
        
        let earth = SCNSphere(radius: 0.3)
        earth.firstMaterial?.diffuse.contents = UIImage(named: "worldmap")
        let earthNode = SCNNode(geometry: earth)
        earthNode.position = SCNVector3(0, 0, -3)
        sceneView.scene.rootNode.addChildNode(earthNode)
        
        
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
