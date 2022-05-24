//
//  SquidEnemy.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-10.
//

import Foundation
import SpriteKit

class SquidEnemy: Enemy{
    
    var placeholderTexture: SKTexture = SKTexture(imageNamed: "joystick")
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(enemyType: EnemyTypes){
        
        super.init(texture: placeholderTexture, color: .clear)
        
        switch enemyType{
            
        case .standard:
            
            texture = SKTexture(imageNamed: "squid_standard_animation_1")
            
        case .flying:
            
            texture = SKTexture(imageNamed: "flying_squid_animation_1")
            hp = Int(Double(EnemiesData.BASE_HP) * (EnemiesData.FLY_HP_MODIFIER))
            baseSpeed = EnemiesData.BASE_SPEED * EnemiesData.FLY_SPEED_MODIFIER
            waveSlotSize = EnemiesData.FLY_ENEMY_SLOT
            
        case .heavy:
            
            texture = SKTexture(imageNamed: "squid_heavy_animation_1")
            hp = Int(Double(EnemiesData.BASE_HP) * (EnemiesData.HEAVY_HP_MODIFIER))
            baseSpeed = EnemiesData.BASE_SPEED * EnemiesData.HEAVY_SPEED_MODIFIER
            waveSlotSize = EnemiesData.HEAVY_ENEMY_SLOT
            armorValue = EnemiesData.SQUID_ARMOUR_VALUE
            
        case .fast:
            
            texture = SKTexture(imageNamed: "squid_fast_animation_1")
            hp = Int(Double(EnemiesData.BASE_HP) * (EnemiesData.FAST_HP_MODIFIER))
            baseSpeed = EnemiesData.BASE_SPEED * EnemiesData.FAST_SPEED_MODIFIER
            waveSlotSize = EnemiesData.FAST_ENEMY_SLOT
            
        case .boss:
            texture = SKTexture(imageNamed: "slime_boss_animation_1")
            print("boss atker spawned")
            attackPower = EnemiesData.BASE_ATTACK_POWER_VALUE * 20
            attackSpeed = EnemiesData.BASE_ATTACK_SPEED_VALUE / 4
            
        }

        startHp = hp
        
    }
    
    override func changeToAtkTexture() {
        
        
        switch self.enemyType{
            
        case .standard:
            
            texture = SKTexture(imageNamed: "squid_standard_atker_animation_1")
            
        case .flying:
            
            texture = SKTexture(imageNamed: "flying_squid_animation_1")
            
        case .heavy:
            
            texture = SKTexture(imageNamed: "squid_heavy_atker_animation_1")
            attackPower = EnemiesData.BASE_ATTACK_POWER_VALUE * 2
            attackSpeed = EnemiesData.BASE_ATTACK_SPEED_VALUE / 2
            
        case .fast:
            
            texture = SKTexture(imageNamed: "squid_fast_atker_animation_1")
            attackPower = EnemiesData.BASE_ATTACK_POWER_VALUE * 10
            attackSpeed = EnemiesData.BASE_ATTACK_SPEED_VALUE / 4
            
        case .boss:
            print("🤔")
        }
    }
    
    
    override func update() {
        super.update()
    }
    
}
