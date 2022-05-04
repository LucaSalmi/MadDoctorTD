//
//  GunProjectile.swift
//  MadDoctorTD
//
//  Created by Daniel Falkedal on 2022-05-04.
//

import Foundation
import SpriteKit

class GunProjectile: Projectile {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    override init(position: CGPoint, target: Enemy){
        
        super.init(position: position, target: target)
        
        texture = SKTexture(imageNamed: "test_projectile")

        
    }
    
    override func destroy() {
        
        GameScene.instance!.gunProjectilesPool.append(self)
        self.removeFromParent()
        
    }
    
}
