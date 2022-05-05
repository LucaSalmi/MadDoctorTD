//
//  FastEnemy.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-05.
//

import Foundation
import SpriteKit

class FastEnemy: Enemy{
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(texture: SKTexture){
        
        super.init(texture: texture, color: .clear)
        hp = EnemiesData.BASE_HP * Int(EnemiesData.FAST_HP_MODIFIER)
        speed = EnemiesData.BASE_SPEED * EnemiesData.FAST_SPEED_MODIFIER
        
    }
    
    override func update() {
        super.update()
    }
    
}
