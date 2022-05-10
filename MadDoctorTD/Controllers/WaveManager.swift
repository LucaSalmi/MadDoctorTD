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
    var waveNumber: Int = 1
    var spawnPoint: CGPoint? = nil
    var waveCreated = false
    
    init(totalSlots: Int, choises: [EnemyTypes], enemyRace: EnemyRaces){
        
        currentScene = GameScene.instance
        spawnPoint = (currentScene?.childNode(withName: "SpawnPoint")!.position) ?? CGPoint(x: 0, y: 0)
        self.totalSlots = totalSlots
        createWave(choises: choises, enemyRace: .slime)
    }
    
    
    private func createWave(choises: [EnemyTypes], enemyRace: EnemyRaces){
        
        if totalSlots < 0{
            
            totalSlots = 10
        }
        
        var occupiedSlots = 0
        
        while occupiedSlots < totalSlots{
            
            let chosen = RandomNumberGenerator.rNG(choises: choises)
            
            let enemy = EnemyFactory().createEnemy(enemyRace: enemyRace, enemyType: chosen)
            enemy.position = spawnPoint!
            enemy.zPosition = 2
            EnemyNodes.enemyArray.append(enemy)
            
            if !checkLimits(){
                occupiedSlots += EnemyNodes.enemyArray.last?.waveSlotSize ?? 1
                
            }
        }
        
        waveCreated = true
    }
    
    
    func update(){
        checkWinCondition()
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
                print("found fast enemy")
                if fastCount > WaveData.FAST_ENEMY_LIMIT{
                    
                    fastToRemove = EnemyNodes.enemyArray.firstIndex(of: obj)
                    
                }
                
            }else if type == .flying{
                
                flyCount += 1
                
                if flyCount > WaveData.FLY_ENEMY_LIMIT{
                    
                    flyToRemove = EnemyNodes.enemyArray.firstIndex(of: obj)
                    
                }
                
            }else if type == .heavy{
                
                heavyCount += 1
                
                if heavyCount > WaveData.HEAVY_ENEMY_LIMIT{
                    
                    heavyToRemove = EnemyNodes.enemyArray.firstIndex(of: obj)
                    
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
    
    func checkWinCondition(){
        
        if EnemyNodes.enemiesNode.children.count == 0 && EnemyNodes.enemyArray.count == 0 {
            
            print("wave cleared")
            GameManager.instance.currentMoney += WaveData.INCOME_PER_WAVE
            waveNumber += 1
            GameManager.instance.currentWave = waveNumber
            waveCreated = false
            currentScene!.waveStartCounter = 600
            currentScene!.isWaveActive = false
            
            print("Current wave number = \(waveNumber)")
            
            if waveNumber > 5 {
                print("Level 1 completed")
            }
            else {
                createWave(choises: [.standard,.fast], enemyRace: .slime)
            }
            
        }
    }
    
    
    
}
