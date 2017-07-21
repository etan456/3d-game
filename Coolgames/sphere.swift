//
//  sphere.swift
//  Coolgames
//
//  Created by Upperline on 7/20/17.
//  Copyright © 2017 Upperline. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

class PrimitivesScene: SCNScene {
    
    override init() {
        super.init()
        self.addSpheres();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSpheres() {
        let sphereGeometry = SCNSphere(radius: 1.0)
        sphereGeometry.firstMaterial?.diffuse.contents = UIColor.red
        let sphereNode = SCNNode(geometry: sphereGeometry)
        self.rootNode.addChildNode(sphereNode)
        
        let secondSphereGeometry = SCNSphere(radius: 0.5)
        secondSphereGeometry.firstMaterial?.diffuse.contents = UIColor.green
        let secondSphereNode = SCNNode(geometry: secondSphereGeometry)
        secondSphereNode.position = SCNVector3(x: 0, y: 1.25, z: 0.0)
        
        self.rootNode.addChildNode(secondSphereNode)
        self.attachChildrenWithAngle(parent: sphereNode, children:[secondSphereNode, sphereNode], angle:20)
    }
    
    func attachChildrenWithAngle(parent: SCNNode, children:[SCNNode], angle:Int) {
        if let parentRadius = (parent.geometry as? SCNSphere)?.radius {
            for index in 0 ..< 2{
                let child = children[index ]
                if let childRadius = (child.geometry as? SCNSphere)?.radius {
                    let radius = parentRadius + childRadius / 2.0
                    child.position = SCNVector3(x:Float(CGFloat(index)), y:Float(radius), z:0.0);
                }
            }
        }
        
    }
    
}

//required init(coder aDecoder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//}



