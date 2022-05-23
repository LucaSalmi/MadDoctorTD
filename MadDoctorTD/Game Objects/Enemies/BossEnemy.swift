//
//  BossEnemy.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-18.
//

import Foundation
import SpriteKit

class Boss: Enemy{
    
    var bossTexture: SKSpriteNode? = nil
    var nextMoveCount: Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(texture: SKTexture){
        
        super.init(texture: texture, color: .clear)
        
        baseSpeed = EnemiesData.BASE_SPEED * EnemiesData.BOSS_SPEED_MODIFIER
        waveSlotSize = EnemiesData.BOSS_ENEMY_SLOT
        hp = Int(Double(EnemiesData.BASE_HP) * (EnemiesData.BOSS_HP_MODIFIER) + (Double(EnemiesData.BASE_HP) * Double(waveSlotSize)))
        startHp = hp
        damageValue = EnemiesData.BOSS_DAMAGE_VALUE
        isAttacker = true
        self.enemyType = .boss
        self.alpha = 0
        attackPower = EnemiesData.BASE_ATTACK_POWER_VALUE * 2
        attackSpeed = EnemiesData.BASE_ATTACK_SPEED_VALUE * 2
        baseSpeed = 1.5
        killValue *= waveSlotSize
        size.width *= 2
        size.height *= 2
        bossTexture = SKSpriteNode(texture: texture, color: .clear, size: self.size)
        bossTexture?.name = "BossTexture"
        physicsBody?.contactTestBitMask = PhysicsCategory.Projectile | PhysicsCategory.Foundation
        physicsBody?.categoryBitMask = PhysicsCategory.Boss
        
    }
    
    override func update() {
        
        bossTexture?.position = self.position
        
        if attackTarget != nil{
            
            super.attack()
            
        }else{
            
            nextMoveCount += 1
            
            if nextMoveCount <= 60{
            
                super.update()
                
            }else if nextMoveCount >= 120{
                
                nextMoveCount = 0
            }
        }
    }
    

    
}
