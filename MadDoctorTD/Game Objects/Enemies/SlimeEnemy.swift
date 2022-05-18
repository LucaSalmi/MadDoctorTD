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
            
        case .boss:
            
            texture = SKTexture(imageNamed: "slime_boss_animation_1")
            baseSpeed = EnemiesData.BASE_SPEED * EnemiesData.BOSS_SPEED_MODIFIER
            waveSlotSize = EnemiesData.BOSS_ENEMY_SLOT
            hp = Int(Double(EnemiesData.BASE_HP) * (EnemiesData.BOSS_HP_MODIFIER) + (Double(EnemiesData.BASE_HP) * Double(waveSlotSize)))
            damageValue = EnemiesData.BOSS_DAMAGE_VALUE
            self.enemyType = .boss
            
        }

        startHp = hp
        
    }
    override func changeTooAtkTexture() {
        
        print("atker spawned. OVERIDING TEXTURE ->")
        
        switch self.enemyType{
            
        case .standard:
            
            texture = SKTexture(imageNamed: "slime_normal_atker_animation_1")
            print("standard atker spawned")
            
        case .flying:
            
            texture = SKTexture(imageNamed: "slime_fly_animation_1")
            
        case .heavy:
            
            texture = SKTexture(imageNamed: "slime_heavy_atker_animation_1")
            print("heavy atker spawned")
            attackPower = EnemiesData.BASE_ATTACK_POWER_VALUE * 2
            attackSpeed = EnemiesData.BASE_ATTACK_SPEED_VALUE / 2
            
        case .fast:
            
            texture = SKTexture(imageNamed: "slime_fast_atker_animation_1")
            print("fast atker spawned")
            attackPower = EnemiesData.BASE_ATTACK_POWER_VALUE * 10
            attackSpeed = EnemiesData.BASE_ATTACK_SPEED_VALUE / 4
            
        case .boss:
            texture = SKTexture(imageNamed: "slime_boss_animation_1")
            print("boss atker spawned")
            attackPower = EnemiesData.BASE_ATTACK_POWER_VALUE * 20
            attackSpeed = EnemiesData.BASE_ATTACK_SPEED_VALUE / 4
            killValue *= waveSlotSize
            
        }
    }
    
    
    override func update() {
        
        super.update()
    }

//    override func getDamage(dmgValue: Int){
//
//        hp -= (dmgValue - armorValue)
//
//        if hp <= 0{
//
//            GameManager.instance.currentMoney += self.killValue
//            print("KILL VALUE for SLIME = \(GameManager.instance.currentMoney)")
//            progressBar.removeFromParent()
//            self.removeFromParent()
//            SoundManager.playSFX(sfxName: SoundManager.slimeDeathSFX )
//
//        }
//
//    }
    
    
}
