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
    var planes:[OverlayPlane] = []
    
    
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
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(taped(sender:)))
        sceneView.addGestureRecognizer(gesture)
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        configuration.planeDetection = .horizontal
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        let plane = OverlayPlane(anchor: anchor as! ARPlaneAnchor) //產出自訂義的可視平台 self.planes.append(plane) //新增到 ViewController 的記錄中
        self.planes.append(plane)
        node.addChildNode(plane) //把自訂義的可視元件，蓋一層到平台上
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let plane = self.planes.filter { plane in
            return plane.anchor.identifier == anchor.identifier
        }.first{
            plane.update(anchor: anchor as! ARPlaneAnchor)
        }
    }
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    @objc func taped(sender:UIGestureRecognizer){
        let view = sender.view as! ARSCNView
         //由傳送者取得 ARView 的實體, 必需為 ARSCNView 才能偵測 plane
        let location = sender.location(in: view)
        let hitResult = view.hitTest(location, types: .existingPlaneUsingExtent) //試試是否是點到 plane
        if let firstHitResults = hitResult.first{
            self.addSphere(hitResult: firstHitResults)
        }
    }
    
    @objc func addSphere(hitResult:ARHitTestResult){
        let sphere = SCNSphere(radius: 0.075)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "worldmap")
        sphere.materials = [material]
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y+0.5, hitResult.worldTransform.columns.3.z)
        sphereNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)//加上物理特性並啟動
        self.sceneView.scene.rootNode.addChildNode(sphereNode)
    }
    
}
