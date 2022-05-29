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
    
    //let wavesPerLevel = 5
    
    var currentBossLevel = WaveData.BOSS_LEVEL
    
    var attackLevel = 6
    var unlockAttackers = false
    var attackSpawnChance = 1 // 10%
    var maximumAtkSpawn = 0
    
    var shouldCreateWave = false
    
    var numberOfAttackers = 0

        
    init(totalSlots: Int, choises: [EnemyTypes]){
        
        currentScene = GameScene.instance
        enemyChoises = choises
        spawnPoint = (currentScene?.childNode(withName: "SpawnPoint")!.position) ?? CGPoint(x: 0, y: 0)
        self.totalSlots = totalSlots

    }
    
    
    private func createWave(choises: [EnemyTypes], enemyRace: EnemyRaces){
        
        waveNumber += 1
        
        if totalSlots < 0{
            
            totalSlots = 5
        }
        
        if waveNumber >= 5 { // level 5 is first boss level
            unlockAttackers = true
            
        }
        if waveNumber == currentBossLevel + 1 {
            currentBossLevel += WaveData.BOSS_LEVEL
        }
        
        if waveNumber == attackLevel + 1{
            attackLevel += 5
        }
        
        if waveNumber == attackLevel {
          
            maximumAtkSpawn = waveNumber / 2 // 50 %
        }
        else {

        maximumAtkSpawn = waveNumber/10 // 10%
        }
        
        var occupiedSlots = 0
        
        if waveNumber == currentBossLevel {
            totalSlots = EnemiesData.BOSS_ENEMY_SLOT
        } else {
            totalSlots = WaveData.LEVEL_WAVE_SIZE + waveNumber
        }
        
        print("totalslots = \(totalSlots) - check 2")
        
        while occupiedSlots < totalSlots{
            
            var chosen: EnemyTypes? = nil
            
            if choises.count > 1{
                
                chosen = RandomNumberGenerator.enemyTypesRNG(choises: choises)
                
            } else {
                
                if !choises.isEmpty{
                    chosen = choises[0]
                }
            }
            
            var enemy: Enemy? = nil
            
            if chosen == .boss{
                enemy = EnemyFactory().createBoss(enemyRace: enemyRace)
            }else{
                enemy = EnemyFactory().createEnemy(enemyRace: enemyRace, enemyType: chosen!)
            }
            
            if enemy == nil{return}
            enemy!.position = spawnPoint!
            enemy!.zPosition = 2
            EnemyNodes.enemyArray.append(enemy!)
            
            
            if numberOfAttackers < maximumAtkSpawn && unlockAttackers && enemy!.enemyType != .flying{
                
                print("spawning atackunits: wavenumber: \(waveNumber)")
                
                if waveNumber == attackLevel{
                    attackSpawnChance = 6 // 60%
                    if waveNumber >= 16{
                        attackSpawnChance = 7 // 70%
                    }
                    
                } else if waveNumber == currentBossLevel {
                    attackSpawnChance = 10
                    
                } else {
                    attackSpawnChance = 1
                    
                    if waveNumber > 16 {
                        attackSpawnChance = 2 // 20
                    }
                }
                
                if RandomNumberGenerator.isAttackerRNG(maxRange: 10, limitForTrue: attackSpawnChance) && enemy!.enemyType != .boss{

                    
                    numberOfAttackers += 1
                    enemy!.isAttacker = true
                    enemy!.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile | PhysicsCategory.Foundation
                    
                    enemy!.changeToAtkTexture()
                }
            }
            
            if !checkLimits(){
                occupiedSlots += EnemyNodes.enemyArray.last?.waveSlotSize ?? 1
                
            }
        }
        
        print("Wavenumber:\(waveNumber)")
        GameManager.instance.currentWave = waveNumber
        
        if waveNumber % WaveData.WAVES_PER_LEVEL == 0 {
            shouldCreateWave = false
        }
        
        numberOfAttackers = 0
    }
    
    func spawnEnemy(){
        
        guard let toSpawn = EnemyNodes.enemyArray.first else{return}
        
        if toSpawn.enemyType == .boss{
            
            let boss = toSpawn as! Boss
            boss.bossTexture?.position = boss.position
            GameScene.instance!.addChild(boss.bossTexture!)
            
        }
        
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
        
        if waveNumber == 3{
            enemyChoises.append(.fast)
        }else if waveNumber == 6{
            enemyChoises.append(.heavy)
        }else if waveNumber == 9{
            enemyChoises.append(.flying)
        }
        if waveNumber >= 9 {
            if waveNumber == currentBossLevel - 1{
                enemyChoises = [.boss]
            } else {
                enemyChoises = [.standard,.heavy,.flying,.fast]
            }
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
            waveStartCounter -= 1
            
            if waveStartCounter <= 0 {
                progressDifficulty()
                let race = GameScene.instance?.enemyRaceSwitch[GameManager.instance.currentLevel-1] ?? EnemyRaces.slime
                createWave(choises: enemyChoises , enemyRace: race)
                
                waveStartCounter = WaveData.WAVE_START_TIME + (totalSlots * WaveData.SPAWN_STANDARD_TIMER)
            }
        }
        
        if (EnemyNodes.enemyArray.count) > 0 {
            spawnCounter += 1
            if spawnCounter >= (WaveData.SPAWN_STANDARD_TIMER){
                spawnEnemy()
                print("Enemies left in current wave \(EnemyNodes.enemyArray.count)")
                
                spawnCounter = 0
            }
        }
        
        if EnemyNodes.enemyArray.count > 0 && EnemyNodes.enemiesNode.children.isEmpty{
            spawnEnemy()
        }

    }
    
    func checkWinCondition(){
        
        if waveNumber < WaveData.WAVES_PER_LEVEL {
            return
        }
        
        if (waveNumber % WaveData.WAVES_PER_LEVEL == 0) &&
                (EnemyNodes.enemyArray.isEmpty && EnemyNodes.enemiesNode.children.isEmpty) {
            print("Current level completed!")
            GameManager.instance.moneyEarned += (WaveData.INCOME_PER_WAVE * WaveData.WAVES_PER_LEVEL) //For UI only
            GameManager.instance.currentMoney += (WaveData.INCOME_PER_WAVE * WaveData.WAVES_PER_LEVEL) //Actually money gain
            GameManager.instance.researchPoints += WaveData.RP_PER_WAVE
            GameManager.instance.survivalBonusNumber += (WaveData.INCOME_PER_WAVE * WaveData.WAVES_PER_LEVEL)
            GameSceneCommunicator.instance.isBuildPhase = true
            
            
            
//            GameScene.instance?.readyButton?.alpha = 1
//            GameScene.instance?.buildFoundationButton?.alpha = 1
//            GameScene.instance?.researchButton?.alpha = 1
//            GameScene.instance?.upgradeMenuToggle?.alpha = 1
            
            GameScene.instance?.uiManager!.showSummary()
            GameScene.instance?.uiManager!.fadeOutPortal = true
            
            SoundManager.stopMusic()
            
            //Door animation:
            if let gameScene = currentScene {
                GameSceneCommunicator.instance.openDoors = true
                gameScene.uiManager!.doorsAnimationCount = gameScene.uiManager!.doorsAnimationTime
            }
        }

        
    }
    
}
