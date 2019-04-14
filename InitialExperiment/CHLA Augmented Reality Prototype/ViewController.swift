//
//  ViewController.swift
//  CHLA Augmented Reality Prototype
//
//  Created by Paul Way on 4/13/19.
//  Copyright © 2019 Paul Way. All rights reserved.
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
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/GameScene.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        guard let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "Photos", bundle: Bundle.main) else{
            return
        }
        
        configuration.trackingImages = trackedImages
        configuration.maximumNumberOfTrackedImages = 1
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        if let imageAnchor = anchor as? ARImageAnchor{
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1, alpha: 0.8)
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi/2
            
            // get ship from other scene
            let shipScene = SCNScene(named: "art.scnassets/ship.scn")!
            let shipNode = shipScene.rootNode.childNodes.first!
            
            shipNode.position = SCNVector3Zero
            shipNode.position.z = 0.15
            
            // add ship to plane
            planeNode.addChildNode(shipNode)
            
            
            node.addChildNode(planeNode)
            
            
            
        }
        
        return node
    }
	
	private func create2DVideoScene (xScale:CGFloat?) -> SKScene {
		var videoPlayer = AVPlayer()
		
		if let validURL = Bundle.main.url(forResource: "video", withExtension: "mp4", subdirectory: "/art.scnassets") {
			let item = AVPlayerItem(url: validURL)
			videoPlayer = AVPlayer(playerItem: item)
		}
		let videoNode = SKVideoNode(avPlayer: videoPlayer)
		videoNode.yScale *= -1
		
		// While debug I observe that if first.node.rotation.y in  - , then we need to change xScale to -1 (when wall draw from right -> left )
		
		if let xScale = xScale {
			videoNode.xScale *= xScale
			
		}
		
		
		videoNode.play()
		
		let skScene = SKScene(size: self.sceneView.frame.size)
		skScene.scaleMode = .aspectFill
		skScene.backgroundColor = .green
		skScene.addChild(videoNode)
		videoNode.position = CGPoint(x: skScene.size.width/2, y: skScene.size.height/2)
		videoNode.size = skScene.size
		return skScene
	}
}
