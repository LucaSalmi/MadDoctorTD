//
//  SniperTurret.swift
//  MadDoctorTD
//
//  Created by Calle Höglund on 2022-05-06.
//

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
                
        projectileType = ProjectileTypes.sniperProjectile
    
        
        attackDamage = Int(Double(attackDamage) * 10)
        
        fireRate = Int(Double(fireRate) * 15)
        
        attackRange = attackRange * 1.5
        
        sniperLegs = SKSpriteNode(texture: SKTexture(imageNamed: "sniper_tower_static_legs"), color: .clear, size: TowerData.TEXTURE_SIZE)
        
        sniperLegs.position = position
        sniperLegs.zPosition = 1
        
        GameScene.instance?.addChild(sniperLegs)
        
        
        
        
    }
    
}
