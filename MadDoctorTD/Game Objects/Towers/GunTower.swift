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
    
    //Use this function when upgrading the tower to get bouncing projectiles
    func activateBouncingProjectiles() {
        projectileType = ProjectileTypes.bouncingProjectile
        towerTexture.texture = SKTexture(imageNamed: "blast_tower_slime")
    }
    
}
