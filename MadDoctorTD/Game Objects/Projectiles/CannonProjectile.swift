//
//  CannonProjectile.swift
//  MadDoctorTD
//
//  Created by Calle Höglund on 2022-05-10.
//

import Foundation
import SpriteKit

class CannonProjectile: AoeProjectile{
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    override init(position: CGPoint, target: Enemy, attackDamage: Int){
        
        super.init(position: position, target: target, attackDamage: attackDamage)
        
        texture = SKTexture(imageNamed: "test_projectile")

        
    }
    
    override func destroy() {
        
        print("self removed")
        //Spawn explosion here
        let enemies = findEnemiesInRadius()
        
        for enemy in enemies {
            enemy.getDamage(dmgValue: attackDamage)
        }
        
        let gameScene = GameScene.instance!
        
       // SoundManager.playMortarSwooshSFX()

                let particle = SKEmitterNode(fileNamed: "CannonExplosion")
                particle!.position = position
                particle!.zPosition = 5
                gameScene.addChild(particle!)

                gameScene.run(SKAction.wait(forDuration: 1)) {
                    particle!.removeFromParent()
                }
        
        self.removeFromParent()
        
        
    }
    
    
    
}
