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
//import MediaPlayer

let pointOfViewCategory:Int = 0x1 << 1
let spaceItemCategory:Int = 0x1 << 1
let collisionMask: Int = 0x1 << 1

class ViewController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var state: Int = 0
	
	var panaromaView: CTPanoramaView!
	
//	var wallPlane: SCNPlane!
	var wallNode: SCNNode!
	var isDoorOpen = false
	
	
	
	
	@IBAction func addButtonTouched(_ sender: Any) {
		

//        let ball = SCNSphere(radius: 0.01)
//        let ballNode = SCNNode(geometry: ball)
//        ballNode.position = SCNVector3Make(0, 0, -0.2)
//
//        let physicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(geometry: ball, options: nil))
//        physicsBody.mass = 1
//        physicsBody.restitution = 0.25
//        physicsBody.friction = 0.75
//        physicsBody.categoryBitMask = pointOfViewCategory
//        physicsBody.contactTestBitMask = spaceItemCategory
//        physicsBody.collisionBitMask = collisionMask
//        ballNode.physicsBody = physicsBody
//
//
//		sceneView.pointOfView?.addChildNode(ballNode)
//        for _ in 1...10 {
//
//
//            let object = SCNCapsule(capRadius: 0.04, height: 0.2)
//            object.firstMaterial?.specular.contents = UIColor.white
//            object.firstMaterial?.diffuse.contents = UIColor(hue: CGFloat(drand48()), saturation: 1, brightness: 1, alpha: 1)
//
//            let node = SCNNode()
//            //node.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.03)
//            node.geometry = object //SCNCapsule(capRadius: 0.04, height: 0.2)
//            //            node.geometry?.firstMaterial?.specular.contents = UIColor.white
//            //            node.geometry?.firstMaterial?.diffuse.contents = UIColor(hue: CGFloat(drand48()), saturation: 1, brightness: 1, alpha: 1)
//
//
//            let x = Float.random(in: -3.0 ..< 3.1)
//            let y = Float.random(in: -0.1 ..< 0.5)
//            let z = Float.random(in: -3.1 ..< 3.1)
//
//            node.position = SCNVector3(x,y,z)
//
//            let physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: object, options: nil))
//            physicsBody.mass = 0
//            physicsBody.restitution = 0.25
//            physicsBody.friction = 0.75
//            physicsBody.categoryBitMask = spaceItemCategory
//            physicsBody.contactTestBitMask = pointOfViewCategory
//            node.physicsBody = physicsBody
//
//            self.sceneView.scene.rootNode.addChildNode(node)
//
//        }

        
        
        
//        placeNextObject()


		
		for i in 1...3 {
			
			var object : SCNGeometry!
			switch(i){
			case 1:
					object = SCNCapsule(capRadius: 0.04, height: 0.2)
				
			case 2:
					object = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.1)
				
			default:
					object = SCNCone(topRadius: 0.1, bottomRadius: 0.2, height: 0.3)
			}
			
			object.firstMaterial?.specular.contents = UIColor.white
			object.firstMaterial?.diffuse.contents = UIColor(hue: CGFloat(drand48()), saturation: 1, brightness: 1, alpha: 1)
			
			let node = SCNNode()
			//node.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.03)
			node.geometry = object //SCNCapsule(capRadius: 0.04, height: 0.2)
			//			node.geometry?.firstMaterial?.specular.contents = UIColor.white
			//			node.geometry?.firstMaterial?.diffuse.contents = UIColor(hue: CGFloat(drand48()), saturation: 1, brightness: 1, alpha: 1)
			
			
			let x = Float.random(in: -1.1 ..< 1.1)
			let y = Float.random(in: -0.1 ..< 0.5)
			let z = Float.random(in: -1.1 ..< 1.1)
			
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
    func placeNextObject(){
        
        let x = Float.random(in: -3.0 ..< 3.1)
        let y = Float.random(in: -0.1 ..< 0.5)
        let z = Float.random(in: -3.0 ..< 3.1)
        
        if(self.state == 0){
            let thrusters = SCNScene(named: "art.scnassets/SpaceEngine.scn")!
            let thrustersNode = thrusters.rootNode.childNode(withName: "default", recursively: true)!
            thrustersNode.position = SCNVector3(x,y,z)
            thrustersNode.scale = SCNVector3(0.05, 0.05, 0.05)
            self.sceneView.scene.rootNode.addChildNode(thrustersNode)
        } else if(self.state == 1) {
            let astro = SCNScene(named: "art.scnassets/Astronaut.scn")!
            let astroNode = astro.rootNode.childNode(withName: "default", recursively: true)!
            astroNode.position = SCNVector3(x,y,z)
            astroNode.scale = SCNVector3(0.2, 0.2, 0.2)
            self.sceneView.scene.rootNode.addChildNode(astroNode)
        }
        
    }
	
	
	func loadPanoView(){
		panaromaView = CTPanoramaView(frame: self.view.bounds)
		
//		let image = UIImage(named: "spherical")
		let image = UIImage(named: "panoramicImage.jpeg")
		
		panaromaView.image = image
		//panaromaView.panoramaType = .spherical
		panaromaView.panoramaType = .cylindrical
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
		
		
		
		wallNode = createWallPlane(imageNamed: "sci-fi-door-3d-closed",  size: CGSize(width: 4.0, height: 2.0), rotation: 0, includesPhysics: true)
		wallNode.position = SCNVector3(0, 0, -2.5)
		self.sceneView.scene.rootNode.addChildNode(wallNode)
		
		let leftWallNode = createWallPlane(imageNamed: "left-wall", size: CGSize(width: 5.0, height: 1.0), rotation: 2, includesPhysics: false)
		leftWallNode.position = SCNVector3(2.0, 0.5, -0.0 )
		self.sceneView.scene.rootNode.addChildNode(leftWallNode)
		
		let rightWallNode = createWallPlane(imageNamed: "right-wall", size: CGSize(width: 5.0, height: 1.0), rotation: 2, includesPhysics: false)
		rightWallNode.position = SCNVector3(-2.0, 0.5, -0.0 )
		self.sceneView.scene.rootNode.addChildNode(rightWallNode)
		
		
//		let backWallNode = createWallPlane(imageNamed: "right-wall", size: CGSize(width: 4.0, height: 2.0), rotation: 0, includesPhysics: false)
//		backWallNode.position = SCNVector3(0, 0, 2.5)
//		self.sceneView.scene.rootNode.addChildNode(backWallNode)
		
		
		// add the wall and door
//		wallPlane  = SCNPlane(width: 3, height: 2.0)
//		wallPlane.firstMaterial?.diffuse.contents = UIImage(named: "sci-fi-door-3d-closed")
//		wallPlane.firstMaterial?.lightingModel = .constant
//		wallPlane.firstMaterial?.isDoubleSided = true
//		wallNode = SCNNode(geometry: wallPlane)
//		wallNode.position = SCNVector3(0,0,-1.5)
//
//
//		let wallBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: wallPlane, options: nil))
//		wallBody.mass = 0
//		wallBody.restitution = 0.25
//		wallBody.friction = 0.75
//		wallBody.categoryBitMask =	spaceItemCategory
//		wallBody.contactTestBitMask =  pointOfViewCategory
//		wallNode.physicsBody = wallBody
//
//		self.sceneView.scene.rootNode.addChildNode(wallNode)
//
//
//		wallNode.transform = SCNMatrix4MakeRotation(-Float.pi / 1.5, 0, 1, 0)
		
		
		playIntroMovie()
		
        
//        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
//
//        // Set the scene to the view
//        sceneView.scene = scene
    }
	
	
	
	func createWallPlane(imageNamed: String, size: CGSize, rotation: Float, includesPhysics: Bool = false) -> SCNNode{
		
		let wallPlane = SCNPlane(width: size.width, height: size.height)
		wallPlane.firstMaterial?.diffuse.contents = UIImage(named: imageNamed)
		wallPlane.firstMaterial?.lightingModel = .constant
		wallPlane.firstMaterial?.isDoubleSided = true
		let node = SCNNode(geometry: wallPlane)
//		wallNode.position = position //SCNVector3(0,0,-1.5)
		
		if(includesPhysics){
			let wallBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: wallPlane, options: nil))
			wallBody.mass = 0
			wallBody.restitution = 0.25
			wallBody.friction = 0.75
			wallBody.categoryBitMask =	spaceItemCategory
			wallBody.contactTestBitMask =  pointOfViewCategory
			node.physicsBody = wallBody
		}
		
		if(rotation > 0){
			node.transform = SCNMatrix4MakeRotation(-Float.pi / rotation, 0, 1, 0)
		}
		
		return node
		
	}
	
	
	
	
	func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
		

        self.state = self.state + 1
		
		if((isDoorOpen == false) && (contact.nodeA == self.wallNode || contact.nodeA == self.wallNode)){
			return
		}
		
		// if the door is open and we touched it
		if (isDoorOpen == true ){
			DispatchQueue.main.async {
				self.loadPanoView()
			}
			return
			
		}
		
		
		if contact.nodeA.physicsBody!.categoryBitMask == pointOfViewCategory {
			contact.nodeB.removeFromParentNode()
//            self.placeNextObject()
		} else {

			contact.nodeA.removeFromParentNode()
//            self.placeNextObject()
		}
		
		if (self.state >= 3){
			wallNode.geometry!.firstMaterial?.diffuse.contents = UIImage(named: "sci-fi-door-3d-open")
			isDoorOpen = true
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
	
	
	var moviePlayer : AVPlayer!
	var playerLayer : AVPlayerLayer!
	var playerView : UIView!
	func playIntroMovie(){
		
		guard let path = Bundle.main.path(forResource: "app-s1", ofType:"mp4") else {
			debugPrint("video.m4v not found")
			return
		}
		
		do {
			try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
			try AVAudioSession.sharedInstance().setActive(true)
		} catch {
			print(error)
		}

		
		let videoURL = URL(fileURLWithPath: path)
		let player = AVPlayer(url: videoURL)
		playerLayer = AVPlayerLayer(player: player)
		
		playerView = UIView(frame: self.view.bounds)
		playerView.layer.addSublayer(playerLayer)
		playerView.clipsToBounds = true
		
		playerLayer.frame = self.view.bounds
		playerView.translatesAutoresizingMaskIntoConstraints = false
		
		playerLayer.backgroundColor = UIColor.white.cgColor
//		self.view.layer.addSublayer(playerLayer)
		self.view.addSubview(playerView)
//
//		NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: object: player.currentItem)

		
//		NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying:),
//											   name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
 
		
		NotificationCenter.default.addObserver(self, selector: #selector(ViewController.playerDidFinishPlaying), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
		
		player.play()
		
		
//		let url = URL (string: "http://jplayer.org/video/m4v/Big_Buck_Bunny_Trailer.m4v")
//		moviePlayer = MPMoviePlayerController(contentURL: url!)
//		if let player = moviePlayer {
//			player.view.frame = self.view.bounds
//			player.view.backgroundColor = UIColor.white
//			player.prepareToPlay()
//			player.scalingMode = .aspectFill
//			self.view.addSubview(player.view)
//		}
//
		
	}
	
	@objc public func playerDidFinishPlaying(note: NSNotification) {
		print("Video Finished")
//		playerLayer.removeFromSuperlayer()
		
		
		
		UIView.animate(withDuration: 0.8) {
			
			
			var frame = self.playerView.frame
			frame.size.width = self.view.frame.size.width / 3.0
			frame.size.height = frame.size.width
			self.playerView.layer.sublayers![0].frame = frame
			
			frame.origin.x = self.view.frame.size.width  - frame.size.width
			self.playerView.frame = frame
			
		}
		
	}
	
}
