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
    var spawnPoint: CGPoint? = nil
    var enemyArray = [Enemy]()
    
    init(totalSlots: Int){
        
        currentScene = GameScene.instance
        spawnPoint = (currentScene?.childNode(withName: "SpawnPoint")!.position) ?? CGPoint(x: 0, y: 0)
        self.totalSlots = totalSlots
        createWave()
    }
    
    
    private func createWave(){
        
        if totalSlots < 0{
            
            totalSlots = 30
        }
        
        var occupiedSlots = 0
        
        for _ in 0...totalSlots{
            
            let x = RandomNumberGenerator.rNG(start: 0, end: 3)
            
            switch x {
                
            case 0:
                
                let enemy = StandardEnemy(texture: SKTexture(imageNamed: "slime animation 1"))
                enemy.position = spawnPoint!
                enemy.zPosition = 2
                enemyArray.append(enemy)
                
            case 1:
                
                let enemy = FastEnemy(texture: SKTexture(imageNamed: "wheelie 1"))
                enemy.position = spawnPoint!
                enemy.zPosition = 2
                enemyArray.append(enemy)
                
            case 2:
                
                let enemy = HeavyEnemy(texture: SKTexture(imageNamed: "ship 1"))
                enemy.position = spawnPoint!
                enemy.zPosition = 2
                enemyArray.append(enemy)
                
            case 3:
                
                let enemy = FlyingEnemy(texture: SKTexture(imageNamed: "joystick"))
                enemy.position = spawnPoint!
                enemy.zPosition = 2
                enemyArray.append(enemy)
                
            default:
                
                let enemy = StandardEnemy(texture: SKTexture(imageNamed: "slime animation 1"))
                enemy.position = spawnPoint!
                enemy.zPosition = 2
                enemyArray.append(enemy)
                
            }
            
            occupiedSlots += enemyArray.last?.waveSlotSize ?? 1
            
            if occupiedSlots >= totalSlots{
                break
            }
        }
    }
    
    func spawnEnemy(){
        
        guard let toSpawn = enemyArray.first else{return}
        currentScene?.enemiesNode.addChild(toSpawn)
        enemyArray.removeFirst()
        
    }
    
    
    
}
