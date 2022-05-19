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
    
    func createBoss() -> Enemy
}

class SlimeFactory: EnemyFactoryProtocol{
    
    func createBoss() -> Enemy {
        
        let boss = Boss(texture: SKTexture(imageNamed: "slime_boss_animation_1"))
        boss.enemyRace = .slime
        return boss
    }
    
    
    func createEnemy(enemyType: EnemyTypes) -> Enemy{
        
        let slime = SlimeEnemy(enemyType: enemyType)
        slime.enemyRace = .slime
        return slime

    }
}

protocol EnemyCreator{
    
    func createEnemy(enemyRace: EnemyRaces, enemyType: EnemyTypes) -> Enemy
    
    func createBoss(enemyRace: EnemyRaces) -> Enemy
    
}

class EnemyFactory: EnemyCreator{
    
    func createBoss(enemyRace: EnemyRaces) -> Enemy {
        
        switch enemyRace {
            
        case .slime:
            return SlimeFactory().createBoss()
        case .squid:
            return SlimeFactory().createBoss()
        }
        
    }
    
    
    func createEnemy(enemyRace: EnemyRaces, enemyType: EnemyTypes) -> Enemy {
        
        switch enemyRace {
        case .slime:
            
            return SlimeFactory().createEnemy(enemyType: enemyType)
            
        case .squid:
            //TO DO replace with right factory
            return SlimeFactory().createEnemy(enemyType: enemyType)
            
        }
    }
    
    
    
}
