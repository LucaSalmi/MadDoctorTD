//
//  CannonTower.swift
//  MadDoctorTD
//
//  Created by Calle Höglund on 2022-05-10.
//

import Foundation
import SpriteKit

class CannonTower: Tower{
    
    let instance = GameScene.instance!
    var distance: CGFloat?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    override init(position: CGPoint, foundation: FoundationPlate, textureName: String){
        
        super.init(position: position, foundation: foundation, textureName: textureName)
        
        towerName = "Cannon Tower"
        projectileType = ProjectileTypes.cannonProjectile
        
        attackDamage = Int(Double(attackDamage) * 4)
        
        fireRate = Int(Double(fireRate) * 6)
        
        attackRange = attackRange * 1.3
        
    }

    override func upgradeParticle() {

        guard let gameScene = GameScene.instance else { return }

        if rangeUpgradeCount >= 3 {

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
    
    override func attackTarget(){

        if currentFireRateTick <= 0 {
            
            switch self.projectileType {
            
            case .mineProjectile:
                let projectile = MineProjectile(position: position, target: currentTarget!, attackDamage: attackDamage)
                print("mine projectile")
                ProjectileNodes.projectilesNode.addChild(projectile)
                            
            default:
                let projectile = CannonProjectile(position: position, target: currentTarget!, attackDamage: attackDamage)
                print("default projectile")
                
                ProjectileNodes.projectilesNode.addChild(projectile)
            }

            currentFireRateTick = fireRate // DO NOT REMOVE UNLESS YOU WANT 3 FPS 
            SoundManager.playCannonFireSFX()

        }
        
        distance = CGPointDistanceSquared(from: position, to: currentTarget!.position)

    }
    
    func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat{
        
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    }
    
    func activateMineProjectiles(){
        projectileType = ProjectileTypes.mineProjectile
        towerTexture.texture = SKTexture(imageNamed: "slime_cannon")
    }
    
    override func upgrade(upgradeType: UpgradeTypes) {
        super.upgrade(upgradeType: upgradeType)

        if rangeUpgradeCount == 3 {
            
            GameScene.instance?.uiManager!.rangeImage?.texture = SKTexture(imageNamed: "range_upgrade_\(rangeUpgradeCount)_cannon_mine")
        }
        
    }
    
}
