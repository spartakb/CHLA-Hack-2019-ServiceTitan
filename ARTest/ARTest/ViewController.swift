//
//  ViewController.swift
//  ARTest
//
//  Created by Spartak Buniatyan on 4/13/19.
//  Copyright © 2019 GSTTest. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CTPanoramaView

let pointOfViewCategory:Int = 0x1 << 0
let spaceItemCategory:Int = 0x1 << 1

class ViewController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate {

    @IBOutlet var sceneView: ARSCNView!
	
	var panaromaView: CTPanoramaView!
	
	@IBAction func addButtonTouched(_ sender: Any) {
		
		
		
		for _ in 1...10 {
			
			
			let object = SCNCapsule(capRadius: 0.04, height: 0.2)
			object.firstMaterial?.specular.contents = UIColor.white
			object.firstMaterial?.diffuse.contents = UIColor(hue: CGFloat(drand48()), saturation: 1, brightness: 1, alpha: 1)
			
			let node = SCNNode()
			//node.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.03)
			node.geometry = object //SCNCapsule(capRadius: 0.04, height: 0.2)
//			node.geometry?.firstMaterial?.specular.contents = UIColor.white
//			node.geometry?.firstMaterial?.diffuse.contents = UIColor(hue: CGFloat(drand48()), saturation: 1, brightness: 1, alpha: 1)
			
			
			let x = Float.random(in: -3.0 ..< 3.1)
			let y = Float.random(in: -0.1 ..< 0.5)
			let z = Float.random(in: -3.1 ..< 3.1)
			
			node.position = SCNVector3(x,y,z)
			
			let physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: object, options: nil))
			physicsBody.mass = 0
			physicsBody.restitution = 0.25
			physicsBody.friction = 0.75
			physicsBody.categoryBitMask = spaceItemCategory
			physicsBody.contactTestBitMask = pointOfViewCategory
			node.physicsBody = physicsBody
			
			self.sceneView.scene.rootNode.addChildNode(node)
			
		}

		
		
	}
	
	
	func loadPanoView(){
		panaromaView = CTPanoramaView(frame: self.view.bounds)
		
		let image = UIImage(named: "spherical")
		
		panaromaView.image = image
		panaromaView.panoramaType = .spherical
//		panaromaView.controlMethod = .touch
		panaromaView.controlMethod = .motion
//		panaromaView.compass =  .compassView
		panaromaView.alpha = 0
		self.view.addSubview(panaromaView)
		
		
		UIView.animate(withDuration: 0.5) {
			self.panaromaView.alpha = 1
			self.sceneView.alpha = 0
			
		}
		
		print("Add Pano View!!!!!")
		
	}
	
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Set the view's delegate
        sceneView.delegate = self
		
		sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
		
		sceneView.autoenablesDefaultLighting = true
		
		sceneView.scene.physicsWorld.contactDelegate = self
		
		
		let ball = SCNSphere(radius: 0.01)
		let ballNode = SCNNode(geometry: ball)
		ballNode.position = SCNVector3Make(0, 0, -0.2)
		
		let physicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(geometry: ball, options: nil))
		physicsBody.mass = 1
		physicsBody.restitution = 0.25
		physicsBody.friction = 0.75
		physicsBody.categoryBitMask = pointOfViewCategory
		physicsBody.contactTestBitMask = spaceItemCategory
		ballNode.physicsBody = physicsBody
		
		sceneView.pointOfView?.addChildNode(ballNode)
		
        
//        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
//
//        // Set the scene to the view
//        sceneView.scene = scene
    }
	
	func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
		
		if contact.nodeA.physicsBody!.categoryBitMask == pointOfViewCategory {
			contact.nodeB.removeFromParentNode()
		} else {
			contact.nodeA.removeFromParentNode()
		}
		
		DispatchQueue.main.async {
			self.loadPanoView()
		}
		
		print("Got contact!!!!")
//		let mask = contact.nodeA.physicsBody!.categoryBitMask | contact.nodeB.physicsBody!.categoryBitMask
//
//		if CollisionTypes(rawValue: mask) == [CollisionTypes.bottom, CollisionTypes.shape] {
//			if contact.nodeA.physicsBody!.categoryBitMask == CollisionTypes.bottom.rawValue {
//				contact.nodeB.removeFromParentNode()
//			} else {
//				contact.nodeA.removeFromParentNode()
//			}
//		}
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
