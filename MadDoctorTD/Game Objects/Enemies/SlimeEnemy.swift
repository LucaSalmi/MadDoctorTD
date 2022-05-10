//
//  SlimeEnemy.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-10.
//

import Foundation
import SpriteKit

class SlimeEnemy: Enemy{
    
    var placeholderTexture: SKTexture = SKTexture(imageNamed: "joystick")
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(enemyType: EnemyTypes){
        
        super.init(texture: placeholderTexture, color: .clear)
        
        switch enemyType{
            
        case .standard:
            
            texture = SKTexture(imageNamed: "slime animation 1")
            
        case .flying:
            
            texture = SKTexture(imageNamed: "squid_animation_1")
            hp = Int(Double(EnemiesData.BASE_HP) * (EnemiesData.FLY_HP_MODIFIER))
            baseSpeed = EnemiesData.BASE_SPEED * EnemiesData.FLY_SPEED_MODIFIER
            waveSlotSize = EnemiesData.FLY_ENEMY_SLOT
            
        case .heavy:
            
            texture = SKTexture(imageNamed: "ship 1")
            hp = Int(Double(EnemiesData.BASE_HP) * (EnemiesData.HEAVY_HP_MODIFIER))
            baseSpeed = EnemiesData.BASE_SPEED * EnemiesData.HEAVY_SPEED_MODIFIER
            waveSlotSize = EnemiesData.HEAVY_ENEMY_SLOT
            armorValue = EnemiesData.SLIME_ARMOUR_VALUE
            
        case .fast:
            
            texture = SKTexture(imageNamed: "wheelie 1")
            hp = Int(Double(EnemiesData.BASE_HP) * (EnemiesData.FAST_HP_MODIFIER))
            baseSpeed = EnemiesData.BASE_SPEED * EnemiesData.FAST_SPEED_MODIFIER
            waveSlotSize = EnemiesData.FAST_ENEMY_SLOT
            
        }

        startHp = hp
        
    }
    
    
    override func update() {
        super.update()
    }
    
    
}
