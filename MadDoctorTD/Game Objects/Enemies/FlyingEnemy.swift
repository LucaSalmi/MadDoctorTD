//
//  FlyingEnemy.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-05.
//

import Foundation
import SpriteKit

class FlyingEnemy: Enemy{
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(texture: SKTexture){
        
        super.init(texture: texture, color: .clear)
        hp = EnemiesData.BASE_HP * Int(EnemiesData.FLY_HP_MODIFIER)
        speed = EnemiesData.BASE_SPEED * EnemiesData.FLY_SPEED_MODIFIER
        waveSlotSize = EnemiesData.FLY_ENEMY_SLOT
        
    }
    
    override func update() {
        //TODO: fly
    }
    
}
