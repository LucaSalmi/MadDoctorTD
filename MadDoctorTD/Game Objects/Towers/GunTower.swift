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
                
        projectileType = ProjectileTypes.gunProjectile.rawValue
    
        attackDamage = Int(Double(attackDamage) * 0.8)
        
        //attackRange = attackRange * 0.1
    }
    
}
