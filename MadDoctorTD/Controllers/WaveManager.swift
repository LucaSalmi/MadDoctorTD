//
//  WaveManager.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-06.
//

import Foundation
import SpriteKit

class WaveManager{
    
    var currentScene: GameScene? = nil
    var totalSlots: Int = 0
    //var totalEnemiesOfWave: Int = 0
    var waveNumber: Int = 0
    var spawnPoint: CGPoint? = nil
    
    var wavesCompleted = 0
    var enemyChoises = [EnemyTypes]()
    
    var spawnCounter = 0
    var waveStartCounter = 0
    
    let wavesPerLevel = 5
    
    var shouldCreateWave = false
    
    var numberOfAttackers = 0
    
    init(totalSlots: Int, choises: [EnemyTypes], enemyRace: EnemyRaces){
        
        currentScene = GameScene.instance
        spawnPoint = (currentScene?.childNode(withName: "SpawnPoint")!.position) ?? CGPoint(x: 0, y: 0)
        self.totalSlots = totalSlots

    }
    
    
    private func createWave(choises: [EnemyTypes], enemyRace: EnemyRaces){
        
        if totalSlots < 0{
            
            totalSlots = 10
        }
        
        var occupiedSlots = 0
        
        while occupiedSlots < totalSlots{
            
            let chosen = RandomNumberGenerator.enemyTypesRNG(choises: choises)
            
            let enemy = EnemyFactory().createEnemy(enemyRace: enemyRace, enemyType: chosen)
            enemy.position = spawnPoint!
            enemy.zPosition = 2
            EnemyNodes.enemyArray.append(enemy)
            
            if numberOfAttackers < WaveData.MAX_ATTACKER_NUMBER {
                
                if RandomNumberGenerator.isAttackerRNG(maxRange: 10, limitForTrue: 5){
                    
                    numberOfAttackers += 1
                    enemy.isAttacker = true
                    enemy.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile | PhysicsCategory.Foundation
                }
            }
            
            if !checkLimits(){
                occupiedSlots += EnemyNodes.enemyArray.last?.waveSlotSize ?? 1
                
            }
        }
        
        waveNumber += 1
        GameManager.instance.currentWave = waveNumber
        
        if waveNumber % wavesPerLevel == 0 {
            shouldCreateWave = false
        }
        
        numberOfAttackers = 0
    }
    
    func spawnEnemy(){
        
        guard let toSpawn = EnemyNodes.enemyArray.first else{return}
        EnemyNodes.enemiesNode.addChild(toSpawn)
        EnemyNodes.enemyArray.removeFirst()
        
    }
    
    
    func checkLimits() -> Bool{
        
        var flyCount = 0
        var fastCount = 0
        var heavyCount = 0
        
        var flyToRemove: Int? = nil
        var heavyToRemove: Int? = nil
        var fastToRemove: Int? = nil
        
        for obj in EnemyNodes.enemyArray{
            
            let type = obj.enemyType
            
            if type == .fast {
                
                fastCount += 1

                if fastCount > WaveData.FAST_ENEMY_LIMIT{
                    
                    fastToRemove = EnemyNodes.enemyArray.firstIndex(of: obj)
                    
                    if obj.isAttacker{
                        numberOfAttackers -= 1
                    }
                    
                }
                
            }else if type == .flying{
                
                flyCount += 1
                
                if flyCount > WaveData.FLY_ENEMY_LIMIT{
                    
                    flyToRemove = EnemyNodes.enemyArray.firstIndex(of: obj)
                    
                    if obj.isAttacker{
                        numberOfAttackers -= 1
                    }
                    
                }
                
            }else if type == .heavy{
                
                heavyCount += 1
                
                if heavyCount > WaveData.HEAVY_ENEMY_LIMIT{
                    
                    heavyToRemove = EnemyNodes.enemyArray.firstIndex(of: obj)
                    
                    if obj.isAttacker{
                        numberOfAttackers -= 1
                    }
                    
                }
            }
        }
        
        var hasDeleted = false
        
        if flyToRemove != nil{
            EnemyNodes.enemyArray.remove(at: flyToRemove!)
            hasDeleted = true
        }
        if fastToRemove != nil{
            EnemyNodes.enemyArray.remove(at: fastToRemove!)
            hasDeleted = true
        }
        if heavyToRemove != nil{
            EnemyNodes.enemyArray.remove(at: heavyToRemove!)
            hasDeleted = true
        }
        
        return hasDeleted
    }
    
    func progressDifficulty(){
        
        if wavesCompleted == 5{
            enemyChoises.append(.heavy)
            totalSlots += 5
        }else if wavesCompleted == 10{
            enemyChoises.append(.flying)
            totalSlots += 10
        }else if wavesCompleted == 15{
            totalSlots += 15
        }
    }
    
    /* UPDATE */
    func update(){
        
        timers()
        checkWinCondition()
        
    }
    
    
    //Timers for starting the wave and then spawn one enemy from the wave
    func timers(){
        
        if shouldCreateWave {
            waveStartCounter += 1
            if waveStartCounter >= WaveData.WAVE_START_TIME {
                
                createWave(choises: [.standard,.fast], enemyRace: .slime)
                
                waveStartCounter = 0
            }
        }
        
        if (EnemyNodes.enemyArray.count) > 0 {
            spawnCounter += 1
            if spawnCounter >= WaveData.SPAWN_STANDARD_TIMER {
                spawnEnemy()
                
                spawnCounter = 0
            }
        }

    }
    
    func checkWinCondition(){
        
        if waveNumber <= 0 {
            return
        }
        
        if (waveNumber % wavesPerLevel == 0) &&
                (EnemyNodes.enemyArray.isEmpty && EnemyNodes.enemiesNode.children.isEmpty) {
            print("Current level completed!")
            GameManager.instance.currentMoney += (WaveData.INCOME_PER_WAVE * wavesPerLevel)
            GameSceneCommunicator.instance.isBuildPhase = true
            SoundManager.stopMusic()
        }

        
    }
    
}
