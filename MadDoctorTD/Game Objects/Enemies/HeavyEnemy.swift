//
//  HeavyEnemy.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-05.
//

import Foundation
import SpriteKit

class HeavyEnemy: Enemy{
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(texture: SKTexture){
        
        super.init(texture: texture, color: .clear)
        hp = EnemiesData.BASE_HP * Int(EnemiesData.HEAVY_HP_MODIFIER)
        speed = EnemiesData.BASE_SPEED * EnemiesData.HEAVY_SPEED_MODIFIER
        waveSlotSize = EnemiesData.HEAVY_ENEMY_SLOT
        
    }
    
    override func update() {
        super.update()
    }
    
}
