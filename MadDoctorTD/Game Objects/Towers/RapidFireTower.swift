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

//    override func attackTarget() {
//
//        super.attackTarget()
//        SoundManager.playRapidFireShotsSFX()
//
//    }
    
    override func update() {
        super.update()
        if resetTexture{
            resetTexture = false
            towerTexture.texture = SKTexture(imageNamed: "speed_tower")
            // bullet drop SFX

        }
    }
    
    func activateSlowProjectiles(){
        slowUpgraded = true
    }
    
}
