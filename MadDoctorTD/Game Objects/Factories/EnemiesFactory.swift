//
//  EnemiesFactory.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-10.
//

import Foundation
import SpriteKit

struct EnemyNodes{
    
    static var enemiesNode: SKNode = SKNode()
    static var enemyArray = [Enemy]()
    
}

protocol EnemyFactoryProtocol{
    
    func createEnemy(enemyType: EnemyTypes) -> Enemy
}

class SlimeFactory: EnemyFactoryProtocol{
    
    func createEnemy(enemyType: EnemyTypes) -> Enemy{
        
        return SlimeEnemy(enemyType: enemyType)

    }
}

protocol EnemyCreator{
    
    func createEnemy(enemyRace: EnemyRaces, enemyType: EnemyTypes) -> Enemy
    
}

class EnemyFactory: EnemyCreator{
    
    func createEnemy(enemyRace: EnemyRaces, enemyType: EnemyTypes) -> Enemy {
        
        switch enemyRace {
        case .slime:
            
            return SlimeFactory().createEnemy(enemyType: enemyType)
        }
        
    }
    
}
