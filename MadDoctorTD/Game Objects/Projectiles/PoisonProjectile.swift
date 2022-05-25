//
//  PoisonProjectile.swift
//  MadDoctorTD
//
//  Created by Calle Höglund on 2022-05-25.
//

import Foundation
import SpriteKit

class PoisonProjectile: SniperProjectile{
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    override init(position: CGPoint, target: Enemy, attackDamage: Int){
        
        super.init(position: position, target: target, attackDamage: attackDamage)
        
    }
    
    override func destroy(){
        let gameScene = GameScene.instance!
        SoundManager.playSniperSFX()
        
        
        if let particle = SKEmitterNode(fileNamed: "GunProjectileImpact") {
            particle.position = position
            particle.zPosition = 5
            gameScene.addChild(particle)
            gameScene.run(SKAction.wait(forDuration: 1)) {
                particle.removeFromParent()
            }
        }
        
        self.removeFromParent()
    }
}
