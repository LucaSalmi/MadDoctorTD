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
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    override init(position: CGPoint, foundation: FoundationPlate, textureName: String){
        
        
        super.init(position: position, foundation: foundation, textureName: textureName)
                
        projectileType = ProjectileTypes.rapidFireProjectile.rawValue
    
        attackDamage = Int(Double(attackDamage) * 0.5)
        
        fireRate = Int(Double(fireRate) * 0.5)
        
        attackRange = attackRange * 0.5
    }
    
}
