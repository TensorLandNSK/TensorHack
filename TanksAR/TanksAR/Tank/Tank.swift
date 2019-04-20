//
//  Tank.swift
//  TanksAR
//
//  Created by Tensor Guest on 19.04.2019.
//  Copyright © 2019 Tensor. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class Tank : SCNNode {
    var tanksChilds: [SCNNode]
    //var boardSize = CGSize(width: 0.3, height: 0.54)
    var scaleFactor = SCNVector3( 0.05, 0.05, 0.05 )
    
    // Tank physics
    let width: Double = 0.1
    let lenght: Double = 0.3
    
    let distanceToSide: Double?
    let distanceToFront: Double?
    let distanceToCorner: Double?
    
    var tankPosition: SCNVector3
    var turretAngle: Double = 0.0
    var cannonAngle: Double = 0.0
    //var turretAngleSpeed: Double = 0.0
    //var cannonAngleSpeed: Double = 0.0
    
    let turretMaxAngle: Double = 180.0*Double.pi/180.0
    let turretMinAngle: Double = -180.0*Double.pi/180.0
    let cannonMaxAngle: Double = 30.0*Double.pi/180.0
    let cannonMinAngle: Double = -10.0*Double.pi/180.0
    
    override init() {
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/TankModel.dae")!
        tanksChilds = scene.rootNode.childNodes
        
        self.tankPosition = scene.rootNode.position
        distanceToSide = width / 2.0
        distanceToFront = lenght / 2.0
        distanceToCorner = sqrt( width*width + lenght*lenght ) / 2.0
        
        super.init()
        
        for childNode in tanksChilds {
            self.addChildNode(childNode as SCNNode)
            //childNode.geometry?.materials = [newMaterial]
        }
        
        self.scale = scaleFactor
        
        //tanksChilds[2].childNodes[0].pivot = SCNMatrix4Translate(tanksChilds[2].childNodes[0].pivot, Float(0.0), Float(1.8), Float(-2.0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rescale(size: CGSize) {
        let minSize: SCNVector3 = self.boundingBox.min
        let maxSize: SCNVector3 = self.boundingBox.max
        let scaleFactor = Float(0.5) * Float(size.width) / abs(maxSize.x - minSize.x)
        
        self.scale = SCNVector3( scaleFactor, scaleFactor, scaleFactor )
    }
    
    func move(direction: SCNVector3) {
        tankPosition.x += direction.x
        tankPosition.y += direction.y
        tankPosition.z += direction.z
        // Move tank SCNNode
        self.localTranslate(by: direction)
    }
    
    func rotate(angle: Double) {
        // Rotate full tank
    }
    
    func rotateTurret(angle: Double) {
        let newTurretAngle = turretAngle + angle*Double.pi/180.0
        if newTurretAngle <= turretMaxAngle && newTurretAngle >= turretMinAngle {
            turretAngle = newTurretAngle
            // Turn turret SCNNode [2]

            //tanksChilds[2].eulerAngles = SCNVector3( tanksChilds[2].eulerAngles.x, Float(turretAngle), tanksChilds[2].eulerAngles.z )
            
            tanksChilds[2].eulerAngles.y = Float(turretAngle)
        }
    }
    
    func adjustCannon(angle: Double) {
        let newCannonAngle = cannonAngle + angle*Double.pi/180.0
        if newCannonAngle <= cannonMaxAngle && newCannonAngle >= cannonMinAngle {
            cannonAngle = newCannonAngle
            // Turn cannon SCNNode [5]
            //tanksChilds[2].childNodes[0].pivot = SCNMatrix4Translate(tanksChilds[2].childNodes[0].pivot, Float(0.0), Float(1.8), Float(2.0))
            tanksChilds[2].childNodes[0].eulerAngles.x = -Float(cannonAngle)
        }
        
    }
}
