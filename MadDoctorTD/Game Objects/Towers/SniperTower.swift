import Foundation
//
//  RapidFireTower.swift
//  MadDoctorTD
//
//  Created by Calle Höglund on 2022-05-06.
//

import SpriteKit

class SniperTower: Tower{
    
    
    var sniperLegs = SKSpriteNode()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    override init(position: CGPoint, foundation: FoundationPlate, textureName: String){
        
        super.init(position: position, foundation: foundation, textureName: textureName)
        
        towerName = "Sniper Tower"
                
        projectileType = ProjectileTypes.sniperProjectile
    
        attackDamage = Int(Double(attackDamage) * 5)
        
        fireRate = Int(Double(fireRate) * 15)
        
        attackRange = attackRange * 1.8
        
        sniperLegs = SKSpriteNode(texture: SKTexture(imageNamed: "sniper_tower_static_legs"), color: .clear, size: TowerData.TEXTURE_SIZE)
        
        sniperLegs.position = position
        sniperLegs.zPosition = 1
        
        GameScene.instance?.addChild(sniperLegs)
        
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
    
    override func onDestroy() {
        
        self.sniperLegs.removeFromParent()
        super.onDestroy()
    }
    
    func activatePosionProjectile(){
        projectileType = ProjectileTypes.poisonProjectile
        towerTexture.texture = SKTexture(imageNamed: "sniper_tower_rotate_slime")
        sniperLegs.texture = SKTexture(imageNamed: "sniper_tower_static_legs_slime")
    }
    
    
}
