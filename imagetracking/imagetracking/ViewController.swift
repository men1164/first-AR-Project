//
//  ViewController.swift
//  imagetracking
//
//  Created by Thanasit Suwanposri on 19/11/2562 BE.
//  Copyright © 2562 Thanasit Suwanposri. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var textNode : SCNNode? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/Gamescene.scn")!

        
        // Set the scene to the view
        sceneView.scene = scene

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        //let configuration = ARWorldTrackingConfiguration()
        let configuration = ARImageTrackingConfiguration()
        
        guard let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "Photo", bundle: Bundle.main) else {
            print("No images available")
            return
        }
        
        configuration.trackingImages = trackedImages
        configuration.maximumNumberOfTrackedImages = 1

        // Run the view's session
        sceneView.session.run(configuration)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        DispatchQueue.main.async {
            
            if let imageAnchor = anchor as? ARImageAnchor {
                
                let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
                
                plane.firstMaterial?.diffuse.contents = UIColor(white: 1, alpha: 0.8)
                
                let planeNode = SCNNode(geometry: plane)
                planeNode.eulerAngles.x = -.pi / 2
                
                let shipScene = SCNScene(named: "art.scnassets/ship.scn")!
                let shipNode = shipScene.rootNode.childNodes.first!
                let pinNode = shipScene.rootNode.childNode(withName: "pinNode", recursively: false)!
                let textNode = shipScene.rootNode.childNode(withName: "textNode", recursively: false)!
                let toiletNode = shipScene.rootNode.childNode(withName: "toilet", recursively: false)!
                let liftNode = shipScene.rootNode.childNode(withName: "lift", recursively: false)!
                let textGen = shipScene.rootNode.childNode(withName: "textGeneral", recursively: false)!
                let textRef = shipScene.rootNode.childNode(withName: "textRef", recursively: false)!
                let textAC = shipScene.rootNode.childNode(withName: "textAC", recursively: false)!
                let textDR = shipScene.rootNode.childNode(withName: "textDR", recursively: false)!
                let textA = shipScene.rootNode.childNode(withName: "textA", recursively: false)!
                let textNA = shipScene.rootNode.childNode(withName: "textNA", recursively: false)!
                let textDT = shipScene.rootNode.childNode(withName: "textDT", recursively: false)!
                
                let action = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 2)
                let forever = SCNAction.repeatForever(action)
                
                let action2 = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 4)
                let forever2 = SCNAction.repeatForever(action2)
                
                let up = SCNAction.move(by: SCNVector3(0, 0.01, 0), duration: 0.7)
                let down = SCNAction.move(by: SCNVector3(0, -0.01, 0), duration: 0.7)
                let squence = SCNAction.sequence([up,down])
                let updown = SCNAction.repeatForever(squence)

                shipNode.position = SCNVector3Zero
                shipNode.position.z = 0.17
                
                pinNode.runAction(updown)
                pinNode.runAction(forever)
                textNode.runAction(updown)
                toiletNode.runAction(forever2)
                liftNode.runAction(forever2)
                
                shipNode.addChildNode(toiletNode)
                shipNode.addChildNode(liftNode)
                shipNode.addChildNode(textNode)
                shipNode.addChildNode(textGen)
                shipNode.addChildNode(textRef)
                shipNode.addChildNode(textAC)
                shipNode.addChildNode(textDR)
                shipNode.addChildNode(textA)
                shipNode.addChildNode(textNA)
                shipNode.addChildNode(textDT)
                shipNode.addChildNode(pinNode)
                
                planeNode.addChildNode(shipNode)
                node.addChildNode(planeNode)
            }
        }
        node.light = SCNLight()
        node.scale = SCNVector3(0.1,0.1,0.1)
        node.light?.intensity = 1000
        node.castsShadow = true
        node.position = SCNVector3(0, 0.01, 0.01)
        node.light?.type = SCNLight.LightType.directional
        node.light?.color = UIColor.white
        return node
    }
    
    
//*********************************************************************************
    
    @objc func handleTap(sender: UITapGestureRecognizer) {

        let sceneViewTappedOn = sender.view as! SCNView
        let touchCoordinates = sender.location(in: sceneViewTappedOn)

        let hitTest = sceneViewTappedOn.hitTest(touchCoordinates)

        if hitTest.isEmpty {
            print("Didn't touch anything")
        }
        else {
            print("touched node")
        }
    }
    
//    func addNode() {
//
//        print("Function worked")
//        let node = SCNNode()
//        let testScene = SCNScene(named: "art.scnassets/test.scn")!
//        let testNode = testScene.rootNode.childNodes.first!
//
//        node.addChildNode(testNode)
//        print(node)
//    }
//***********************************************************************************
    
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//        let a = CGPoint(x: 0, y: 0)
//
//        if let touch = event?.allTouches?.first {
//
//        let loc:CGPoint = touch.location(in: touch.view)
//        print(loc)
//            if loc == a {
//                print("match")
//            }
//
//        }
//    }
    
//    extension SCNNode {
//
//        func hasAncestor(_ node: SCNNode) -> Bool {
//            if self === node {
//                return true // this is the node you're looking for
//            }
//            if self.parent == nil {
//                return false // target node can't be a parent/ancestor if we have no parent
//            }
//            if self.parent === node {
//                return true // target node is this node's direct parent
//            }
//            // otherwise recurse to check parent's parent and so on
//            return self.parent?.childNodes
//        }
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//        let touch = touches.first!
//        if(touch.view == self.sceneView){
//        print("touch working")
//            let viewTouchLocation:CGPoint = touch.location(in: sceneView)
//            guard let result = sceneView.hitTest(viewTouchLocation, options: nil).first else {
//            return
//            }
//            if let shipNode = shipNode, result.node.hasAncestor(shipNode) {
//                print("match")
//            }
//        }
//    }
    
}

extension Int {
    
    var degreesToRadians: Double {return Double(self) * .pi/180}
}
