//
//  PhysicsExtension.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-03.
//

import Foundation
import SpriteKit

extension GameScene: SKPhysicsContactDelegate{
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
    }
    
}
