//
//  Foundation.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-03.
//

import Foundation
import SpriteKit

class FoundationPlate: SKSpriteNode{
    
    var builtUponTile: ClickableTile?
    var hasTower = false
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    init(position: CGPoint, tile: ClickableTile){
        
        self.builtUponTile = tile
        let texture: SKTexture = SKTexture(imageNamed: "Water_Grid_Center")
        super.init(texture: texture, color: .clear, size: FoundationData.size)
        name = "Foundation"
        self.position = position
        zPosition = 1
        physicsBody = SKPhysicsBody(circleOfRadius: FoundationData.size.width/2)
        physicsBody?.categoryBitMask = PhysicsCategory.Foundation
        physicsBody?.collisionBitMask = 0
        physicsBody?.restitution = 0
        physicsBody?.isDynamic = true
        physicsBody?.friction = 0
        physicsBody?.allowsRotation = false
        
    }
    
    func onClick(){
        
        
        if hasTower {
            return
            
        }
        let communicator = GameSceneCommunicator.instance
        communicator.cancelAllMenus()
        
        
        communicator.currentFoundation = self
        communicator.showTowerMenu = true
        
    }
    
}