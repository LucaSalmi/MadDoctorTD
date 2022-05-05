//
//  StandardEnemy.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-05.
//

import Foundation
import SpriteKit

class StandardEnemy: Enemy{
    
    var hp = EnemiesData.baseHP
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(texture: SKTexture){
        
        super.init(texture: texture, color: .clear)
        
    }
    
    override func update() {
        super.update()
    }
    
    override func getDamage(dmgValue: Int) {
        
        hp -= dmgValue
        
        if hp <= 0{
            
            self.removeFromParent()
            
        }
    }
    
    
    
}
