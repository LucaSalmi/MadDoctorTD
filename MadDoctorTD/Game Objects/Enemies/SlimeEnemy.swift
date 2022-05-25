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
            self.enemyType = .standard
            
        case .flying:
            
            texture = SKTexture(imageNamed: "slime_fly_animation_1")
            hp = Int(Double(EnemiesData.BASE_HP) * (EnemiesData.FLY_HP_MODIFIER))
            baseSpeed = EnemiesData.BASE_SPEED * EnemiesData.FLY_SPEED_MODIFIER
            waveSlotSize = EnemiesData.FLY_ENEMY_SLOT
            self.enemyType = .flying
            
        case .heavy:
            
            texture = SKTexture(imageNamed: "slime_heavy_animation_1")
            hp = Int(Double(EnemiesData.BASE_HP) * (EnemiesData.HEAVY_HP_MODIFIER))
            baseSpeed = EnemiesData.BASE_SPEED * EnemiesData.HEAVY_SPEED_MODIFIER
            waveSlotSize = EnemiesData.HEAVY_ENEMY_SLOT
            armorValue = EnemiesData.SLIME_ARMOUR_VALUE
            self.enemyType = .heavy
            
        case .fast:
            
            texture = SKTexture(imageNamed: "slime_fast_animation_1")
            hp = Int(Double(EnemiesData.BASE_HP) * (EnemiesData.FAST_HP_MODIFIER))
            baseSpeed = EnemiesData.BASE_SPEED * EnemiesData.FAST_SPEED_MODIFIER
            waveSlotSize = EnemiesData.FAST_ENEMY_SLOT
            self.enemyType = .fast
            
        default:
            print("🤔")
           
        }

        startHp = hp
        createSlimeAnimations(enemyType: self.enemyType)
        
    }
    override func changeToAtkTexture() {
        
        
        switch self.enemyType{
            
        case .standard:
            
            texture = SKTexture(imageNamed: "slime_standard_atker_animation_1")
            
        case .flying:
            
            texture = SKTexture(imageNamed: "slime_fly_animation_1")
            
        case .heavy:
            
            texture = SKTexture(imageNamed: "slime_heavy_atker_animation_1")
            attackPower = EnemiesData.BASE_ATTACK_POWER_VALUE * 2
            attackSpeed = EnemiesData.BASE_ATTACK_SPEED_VALUE * 2
            
        case .fast:
            
            texture = SKTexture(imageNamed: "slime_fast_atker_animation_1")
            attackPower = EnemiesData.BASE_ATTACK_POWER_VALUE / 2
            attackSpeed = EnemiesData.BASE_ATTACK_SPEED_VALUE / 2
            
        case .boss:
            print("🤔")
        }
    }
    
    
    override func update() {
        
        
        super.update()
    }
    
    
}



