//
//  RapidFireTower.swift
//  MadDoctorTD
//
//  Created by Calle Höglund on 2022-05-06.
//

import Foundation
import SpriteKit

class RapidFireTower: Tower{
    
    var fireLeft = false
    var resetTexture = false
    
    var slowUpgraded = false

    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    override init(position: CGPoint, foundation: FoundationPlate, textureName: String){
        
        
        super.init(position: position, foundation: foundation, textureName: textureName)
                
        towerName = "Rapid Tower" 
        projectileType = ProjectileTypes.rapidFireProjectile
    
        attackDamage = Int(Double(attackDamage) * 0.8)
        
        fireRate = Int(Double(fireRate) * 0.5)
        
        attackRange = attackRange * 0.5

    }

    override func upgradeParticle() {

        guard let gameScene = GameScene.instance else { return }

        if rateOfFireUpgradeCount >= 3 {

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
    
    override func update() {
        super.update()
        
        if resetTexture{
            resetTexture = false
            if slowUpgraded{
                towerTexture.texture = SKTexture(imageNamed: "speed_tower_slime")
            }else{
                towerTexture.texture = SKTexture(imageNamed: "speed_tower")
            }
            
            // bullet drop SFX

        }
    }
    
    func activateSlowProjectiles(){
        slowUpgraded = true
    }
    
}
