//
//  BossEnemy.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-18.
//

import Foundation
import SpriteKit

//creates a boss of a specific race, it handles all the stats change and special behaviour that differs from every other enemy
class Boss: Enemy{
    
    var bossTexture: SKSpriteNode? = nil
    var nextMoveCount: Int = 0
    var bossSteps = 0
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(texture: SKTexture){
        
        super.init(texture: texture, color: .red)
        
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
        let size = CGSize(width: self.size.width * 4, height: self.size.height * 4)
        bossTexture = SKSpriteNode(texture: texture, color: .clear, size: size)
        bossTexture?.name = "BossTexture"
        bossTexture?.zPosition = self.zPosition
        physicsBody = SKPhysicsBody(circleOfRadius: size.width/2.5)
        physicsBody?.contactTestBitMask = PhysicsCategory.Projectile | PhysicsCategory.Foundation
        physicsBody?.categoryBitMask = PhysicsCategory.Boss
        
        hpBar?.position = bossTexture!.position
        enemyShadow?.size.width = bossTexture!.size.width + shadowSizeDifference
        enemyShadow?.size.height = bossTexture!.size.height + shadowSizeDifference
        enemyShadow?.zPosition = bossTexture!.zPosition - 1
        
    }
    
    func findAnimations(){
        
        switch self.enemyRace{
            
        case .slime:
            createSlimeAnimations(enemyType: .boss, textureName: "boss_slime_animation_")
            
        case .squid:
            createSquidAnimations(enemyType: .boss, textureName: "squid_boss_animation_")
        case .none:
            print("🤔")
        
        }
        
        
    }
    
    override func update() {
        
        bossTexture?.position = self.position
        
        if attackTarget != nil {
            
            super.attack()
            
        } else {
            
            nextMoveCount += 1
            
            if nextMoveCount <= 60 {
            
                super.update()
                
            } else if nextMoveCount >= 120 {
                
                nextMoveCount = 0
                
            } else if nextMoveCount == 61 {
                
                PhysicsUtils.shakeCamera(duration: 1)
                SoundManager.playGiantStepSFX(scene: GameScene.instance!)

            }
        }
    }
}
