//
//  GameViewController.swift
//  Coolgames
//
//  Created by Upperline on 7/18/17.
//  Copyright © 2017 Upperline. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController, SCNSceneRendererDelegate {

    var sphere = PrimitivesScene()
    var gameView:SCNView!
    var gameScene:SCNScene!
    var cameraNode:SCNNode!
    var targetCreationTime:TimeInterval = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Setup for 3d
        initView()
        initscene()
        initCamera()
        // Add shapes
        
        addSpheres() // adds a sphere
        
//        let background = UIImage(named: "Cool-Apple-iPhone-6-Wallpaper-2")
//
//        var imageView : UIImageView!
//        imageView = UIImageView(frame: view.bounds)
//        imageView.contentMode =  UIViewContentMode.scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.image = background
//        imageView.center = view.center
//       // view.addSubview(imageView)
//        self.view.sendSubview(toBack: imageView)
//        
//        
    }
  
    func initView(){
        
        gameView = self.view as! SCNView
        gameView.allowsCameraControl = true
        gameView.autoenablesDefaultLighting = true
        let background = UIImage(named: "Cool-Apple-iPhone-6-Wallpaper-2")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        // view.addSubview(imageView)
        self.gameView.sendSubview(toBack: imageView)
        gameView.delegate = self
        
    }
    
    
    func initscene(){
        gameScene = SCNScene()
        gameView.scene = gameScene
        
        gameView.isPlaying = true
    }
    
    
    func initCamera(){
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        
        cameraNode.position = SCNVector3(x: 0, y: 10, z: 15)
    
        gameScene.rootNode.addChildNode(cameraNode)
    
    
    }
    
    
    func createTarget(){
       
        let geometry:SCNGeometry = SCNPyramid(width: 1, height: 1, length: 1)
        
        let randomColor = arc4random_uniform(2) == 0 ? UIColor.yellow : UIColor.green
        
        geometry.materials.first?.diffuse.contents = randomColor
        
        let geometryNode = SCNNode(geometry: geometry)
        geometryNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        
        if randomColor == UIColor.red{
            geometryNode.name = "enemy"
            
            
        }else{
            geometryNode.name = "friend"
            
        }
        
        
       
        
        gameScene.rootNode.addChildNode(geometryNode)
        
        let randomDirection:Float = arc4random_uniform(2) == 0 ? -1.0: 1.0
        
        
        let force = SCNVector3(x: randomDirection, y: 15, z: 0)
        
        
        geometryNode.physicsBody?.applyForce(force, at: SCNVector3(x: 0.05, y: 0.05, z: 0.05), asImpulse: true)
        
    }
    func addSpheres() {
        let sphereGeometry = SCNSphere(radius: 1.0)
        let sphereNode = SCNNode(geometry: sphereGeometry)
        let randomColor = arc4random_uniform(2) == 0 ? UIColor.blue : UIColor.magenta
        sphereGeometry.firstMaterial?.diffuse.contents = randomColor
        sphereNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape:nil)
        
        
        gameScene.rootNode.addChildNode(sphereNode)
        
        let randomDirection:Float = arc4random_uniform(2) == 0 ? -1.0: 1.0
        
        
        let force = SCNVector3(x: randomDirection, y: 15, z: 0)
        
        
        sphereNode.physicsBody?.applyForce(force, at: SCNVector3(x: 0.05, y: 0.05, z: 0.05), asImpulse: true)
        

        
        //sphereNode.position = SCNVector3(x: 0, y: 2.25, z: 0.0)
        
        
        
        gameScene.rootNode.addChildNode(sphereNode)
    }

    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if time > targetCreationTime {
                createTarget()
            addSpheres()
            targetCreationTime = time + 0.6
        }
    }
    func renderer2(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if time > targetCreationTime  {
            addSpheres()
            targetCreationTime = time + 0.6
        }
    cleanUp()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        let location = touch.location(in: gameView)
        
        let hitList = gameView.hitTest(location, options: nil)
        
        if let hitObject = hitList.first{
            let node = hitObject.node
            
            if node.name == "friend" {
                node.removeFromParentNode()
            }
        }
        
    }
    
    
    
    
    func cleanUp(){
        for node in gameScene.rootNode.childNodes{
            if node.presentation.position.y < -2{
                node.removeFromParentNode()
                self.gameView.backgroundColor = UIColor.yellow
            }else{
                node.removeFromParentNode()
                self.gameView.backgroundColor = UIColor.green

            }
        }
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
