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
    
    override init(position: CGPoint, target: Enemy, attackDamage: Int){
        
        super.init(position: position, target: target, attackDamage: attackDamage)
        
        texture = SKTexture(imageNamed: "test_projectile")

        
    }
    
    override func destroy() {
        
        let gameScene = GameScene.instance!
        
        SoundManager.playSFX(sfxName: SoundManager.gunProjectileImpactSFX)
        
        let particle = SKEmitterNode(fileNamed: "GunProjectileImpact")
        particle!.position = position
        particle!.zPosition = 5
        gameScene.addChild(particle!)
        gameScene.run(SKAction.wait(forDuration: 1)) {
            particle!.removeFromParent()
        }
        
        //TODO: TAKE THIS BACK FOR OBJECTPOOLING AND SOLVE BUG
        //TODO: bullets not spawning correctly
        //GameScene.instance!.gunProjectilesPool.append(self)
        self.removeFromParent()
        
    }
    
}
