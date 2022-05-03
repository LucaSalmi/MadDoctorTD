//
//  Foundation.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-03.
//

import Foundation
import SpriteKit

class FoundationPlate: SKSpriteNode{
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    init(position: CGPoint){
        
        let texture: SKTexture? = nil
        super.init(texture: texture, color: .red, size: FoundationData.size)
        name = "Foundation"
        zPosition = 1
        physicsBody = SKPhysicsBody(circleOfRadius: FoundationData.size.width/2)
        physicsBody?.categoryBitMask = PhysicsCategory.Foundation
        physicsBody?.collisionBitMask = PhysicsCategory.Enemy
        physicsBody?.restitution = 0
        physicsBody?.allowsRotation = false
        
    }
    
}
