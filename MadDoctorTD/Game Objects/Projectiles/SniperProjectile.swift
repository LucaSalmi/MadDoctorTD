//
//  GunProjectile.swift
//  MadDoctorTD
//
//  Created by Daniel Falkedal on 2022-05-04.
//

import Foundation
import SpriteKit

class SniperProjectile: Projectile {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    override init(position: CGPoint, target: Enemy, attackDamage: Int){
        
        super.init(position: position, target: target, attackDamage: attackDamage)
        
        texture = SKTexture(imageNamed: "test_projectile")
        
        speed *= ProjectileData.SNIPER_MODIFIER

        
    }
    
    override func destroy() {
        
        let gameScene = GameScene.instance!
        
        //SoundManager.playSFX(sfxName: SoundManager.gunProjectileImpactSFX)

        //SoundManager.playSFX(sfxName: SoundManager.sniperProjectileImpactSFX)
        SoundManager.playSniperSFX()
        
        let particle = SKEmitterNode(fileNamed: "GunProjectileImpact")
        particle!.position = position
        particle!.zPosition = 5
        gameScene.addChild(particle!)
        gameScene.run(SKAction.wait(forDuration: 1)) {
            gameScene.removeFromParent()
        }
        
        //TODO: TAKE THIS BACK FOR OBJECTPOOLING AND SOLVE BUG
        //TODO: bullets not spawning correctly
        //GameScene.instance!.gunProjectilesPool.append(self)
        self.removeFromParent()
        
    }
    
}

