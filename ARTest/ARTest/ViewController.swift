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

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
	
	@IBAction func addButtonTouched(_ sender: Any) {
		
		for _ in 1...10 {
			
			let node = SCNNode()
			//node.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.03)
			node.geometry = SCNCapsule(capRadius: 0.04, height: 0.2)
			node.geometry?.firstMaterial?.specular.contents = UIColor.white
			node.geometry?.firstMaterial?.diffuse.contents = UIColor(hue: CGFloat(drand48()), saturation: 1, brightness: 1, alpha: 1)
			
			let x = Float.random(in: -3.0 ..< 3.1)
			let y = Float.random(in: -0.1 ..< 0.5)
			let z = Float.random(in: -3.1 ..< 3.1)
			
			node.position = SCNVector3(x,y,z)
			self.sceneView.scene.rootNode.addChildNode(node)
			
		}

		
		
	}
	
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
		
		sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
		
		sceneView.autoenablesDefaultLighting = true
        
//        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
//
//        // Set the scene to the view
//        sceneView.scene = scene
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
