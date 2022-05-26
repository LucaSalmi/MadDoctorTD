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
    var animationString: String?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(enemyType: EnemyTypes){
        
        super.init(texture: placeholderTexture, color: .clear)
        
        self.enemyType = enemyType
        self.size.width = 70
        self.size.height = 70
        
        switch enemyType{
            
        case .standard:
            
            texture = SKTexture(imageNamed: "squid_normal_animation_1")
            self.animationString = "squid_normal_animation_"
        case .flying:
            
            texture = SKTexture(imageNamed: "squid_fly_animation_1")
            hp = Int(Double(EnemiesData.BASE_HP) * (EnemiesData.FLY_HP_MODIFIER))
            baseSpeed = EnemiesData.BASE_SPEED * EnemiesData.FLY_SPEED_MODIFIER
            waveSlotSize = EnemiesData.FLY_ENEMY_SLOT
            self.animationString = "squid_fly_animation_"
            
        case .heavy:
            
            texture = SKTexture(imageNamed: "squid_heavy_animation_1")
            hp = Int(Double(EnemiesData.BASE_HP) * (EnemiesData.HEAVY_HP_MODIFIER))
            baseSpeed = EnemiesData.BASE_SPEED * EnemiesData.HEAVY_SPEED_MODIFIER
            waveSlotSize = EnemiesData.HEAVY_ENEMY_SLOT
            armorValue = EnemiesData.SQUID_ARMOUR_VALUE
            self.animationString = "squid_heavy_animation_"
            
        case .fast:
            
            texture = SKTexture(imageNamed: "squid_fast_animation_1")
            hp = Int(Double(EnemiesData.BASE_HP) * (EnemiesData.FAST_HP_MODIFIER))
            baseSpeed = EnemiesData.BASE_SPEED * EnemiesData.FAST_SPEED_MODIFIER
            waveSlotSize = EnemiesData.FAST_ENEMY_SLOT
            self.animationString = "squid_fast_animation_"
            
        default:
            print("🤔")
            
        }

        startHp = hp
        createSquidAnimations(enemyType: self.enemyType, textureName: animationString!)
        
    }
    
    override func changeToAtkTexture() {
        
        
        switch self.enemyType{
            
        case .standard:
            
            texture = SKTexture(imageNamed: "squid_normal_atker_animation_1")
            self.animationString = "squid_normal_atker_animation_"
            
        case .heavy:
            
            texture = SKTexture(imageNamed: "squid_heavy_atker_animation_1")
            attackPower = EnemiesData.BASE_ATTACK_POWER_VALUE * 2
            attackSpeed = EnemiesData.BASE_ATTACK_SPEED_VALUE / 2
            self.animationString = "squid_heavy_atker_animation_"
            
        case .fast:
            
            texture = SKTexture(imageNamed: "squid_fast_atker_animation_1")
            attackPower = EnemiesData.BASE_ATTACK_POWER_VALUE * 10
            attackSpeed = EnemiesData.BASE_ATTACK_SPEED_VALUE / 4
            self.animationString = "squid_fast_atker_animation_"
            
        default:
            print("🤔")
        }
        
        self.animationFrames.removeAll()
        createSquidAnimations(enemyType: self.enemyType, textureName: self.animationString!)
        
    }
    
    
    override func update() {
        super.update()
    }
    
}
