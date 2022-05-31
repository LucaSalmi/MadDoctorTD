//
//  GunTower.swift
//  MadDoctorTD
//
//  Created by Calle Höglund on 2022-05-04.
//

import Foundation
import SpriteKit
import SwiftUI

class GunTower: Tower{
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    override init(position: CGPoint, foundation: FoundationPlate, textureName: String){
        
        
        super.init(position: position, foundation: foundation, textureName: textureName)
        
        towerName = "Gun Tower"
                
        projectileType = ProjectileTypes.gunProjectile
    
        attackDamage = Int(Double(attackDamage) * 1.2)
        
        fireRate = Int(Double(fireRate) * 1.2)
        
        attackRange = attackRange * 1
        
        //attackRange = attackRange * 0.1
        
    }

    override func upgradeParticle() {

        guard let gameScene = GameScene.instance else { return }

        if damageUpgradeCount >= 3 {

            let particleTwo = SKEmitterNode(fileNamed: "sparkle_emitter_upgrade_full")

            particleTwo!.position = position
            particleTwo!.zPosition = 5
            gameScene.addChild(particleTwo!)

            gameScene.run(SKAction.wait(forDuration: 0.5)) {
                    particleTwo!.removeFromParent()
                }

        } else {

            let particle = SKEmitterNode(fileNamed: "sparkle_emitter")

            particle!.position = position
            particle!.zPosition = 5
            gameScene.addChild(particle!)

            gameScene.run(SKAction.wait(forDuration: 0.5)) {
                    particle!.removeFromParent()
                }
        }
    }
    
    //Use this function when upgrading the tower to get bouncing projectiles
    func activateBouncingProjectiles() {
        projectileType = ProjectileTypes.bouncingProjectile
        towerTexture.texture = SKTexture(imageNamed: "blast_tower_slime")
    }
    
    override func upgrade(upgradeType: UpgradeTypes) {
        super.upgrade(upgradeType: upgradeType)

        if damageUpgradeCount == 3 {
            
            GameScene.instance?.uiManager!.damageImage?.texture = SKTexture(imageNamed: "power_upgrade_\(damageUpgradeCount)_bounce")
        }
        
    }
}
