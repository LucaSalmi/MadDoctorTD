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
    var enemyArray = [Enemy]()
    var waveCreated = false
    
    init(totalSlots: Int, choises: [EnemyTypes]){
        
        currentScene = GameScene.instance
        spawnPoint = (currentScene?.childNode(withName: "SpawnPoint")!.position) ?? CGPoint(x: 0, y: 0)
        self.totalSlots = totalSlots
        createWave(choises)
    }
    
    
    private func createWave(_ choises: [EnemyTypes]){
        
        if totalSlots < 0{
            
            totalSlots = 10
        }
        
        var occupiedSlots = 0
        
        while occupiedSlots < totalSlots{
            
            let chosen = RandomNumberGenerator.rNG(choises: choises)
            
            switch chosen {
                
            case .standard:
                
                let stEnemy = StandardEnemy(texture: SKTexture(imageNamed: "slime animation 1"))
                stEnemy.position = spawnPoint!
                stEnemy.zPosition = 2
                enemyArray.append(stEnemy)
                
            case .fast:
                
                let fEnemy = FastEnemy(texture: SKTexture(imageNamed: "wheelie 1"))
                fEnemy.position = spawnPoint!
                fEnemy.zPosition = 2
                enemyArray.append(fEnemy)
                
            case .heavy:
                
                let hEnemy = HeavyEnemy(texture: SKTexture(imageNamed: "ship 1"))
                hEnemy.position = spawnPoint!
                hEnemy.zPosition = 2
                enemyArray.append(hEnemy)
                
            case .flying:
                
                let fEnemy = FlyingEnemy(texture: SKTexture(imageNamed: "squid_animation_1"))
                fEnemy.position = spawnPoint!
                fEnemy.zPosition = 3
                enemyArray.append(fEnemy)
                
            }
            
            if !checkLimits(){
                occupiedSlots += enemyArray.last?.waveSlotSize ?? 1
                
                
            }
        }
        print("totalEnemies: \(enemyArray.count)")
        waveCreated = true
    }
    
    func update(){
        checkWinCondition()
    }
    
    func spawnEnemy(){
        
        guard let toSpawn = enemyArray.first else{return}
        currentScene?.enemiesNode.addChild(toSpawn)
        enemyArray.removeFirst()
        
    }
    
    func checkLimits() -> Bool{
        
        var flyCount = 0
        var fastCount = 0
        var heavyCount = 0
        
        var flyToRemove: Int? = nil
        var heavyToRemove: Int? = nil
        var fastToRemove: Int? = nil
        
        for obj in enemyArray{
            
            if obj is FastEnemy{
                
                fastCount += 1
                print("found fast enemy")
                if fastCount > WaveData.FAST_ENEMY_LIMIT{
                    
                    fastToRemove = enemyArray.firstIndex(of: obj)
                    
                }
                
            }else if obj is FlyingEnemy{
                
                flyCount += 1
                
                if flyCount > WaveData.FLY_ENEMY_LIMIT{
                    
                    flyToRemove = enemyArray.firstIndex(of: obj)
                    
                }
                
            }else if obj is HeavyEnemy{
                
                heavyCount += 1
                
                if heavyCount > WaveData.HEAVY_ENEMY_LIMIT{
                    
                    heavyToRemove = enemyArray.firstIndex(of: obj)
                    
                }
            }
        }
        
        var hasDeleted = false
        
        if flyToRemove != nil{
            enemyArray.remove(at: flyToRemove!)
            hasDeleted = true
        }
        if fastToRemove != nil{
            enemyArray.remove(at: fastToRemove!)
            hasDeleted = true
        }
        if heavyToRemove != nil{
            enemyArray.remove(at: heavyToRemove!)
            hasDeleted = true
        }
        
        
        return hasDeleted
    }
    
    func checkWinCondition(){
        
        if GameScene.instance!.enemiesNode.children.count == 0 && enemyArray.count == 0 {
            
            print("wave cleared")
            waveNumber += 1
            waveCreated = false
            currentScene!.waveStartCounter = 600
            currentScene!.isWaveActive = false
            
            print("Current wave number = \(waveNumber)")
            
            if waveNumber > 5 {
                print("Level 1 completed")
            }
            else {
                createWave([.standard,.fast])
            }
            
        }
    }
    
    
    
}
