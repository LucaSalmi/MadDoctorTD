//
//  BulletFactory.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-10.
//

import Foundation
import SpriteKit
//Constant data for projectiles
struct ProjectileNodes{
    
    static var projectilesNode: SKNode = SKNode()
    static var gunProjectilesPool = [GunProjectile]()

}
//protocol for projectile factory
protocol ProjectileFactoryProtocol{
    
    func createProjectile(position: CGPoint, target: Enemy, attackDamage: Int) -> Projectile
    
}

class GunProjectileFactory: ProjectileFactoryProtocol{
    
    func createProjectile(position: CGPoint, target: Enemy, attackDamage: Int) -> Projectile {
        return GunProjectile(position: position, target: target, attackDamage: attackDamage)
    }

}

class SniperProjectileFactory: ProjectileFactoryProtocol{
    
    func createProjectile(position: CGPoint, target: Enemy, attackDamage: Int) -> Projectile {
        return SniperProjectile(position: position, target: target, attackDamage: attackDamage)
    }
    
}

class BouncingProjectileFactory: ProjectileFactoryProtocol {
    
    func createProjectile(position: CGPoint, target: Enemy, attackDamage: Int) -> Projectile {
        return BouncingProjectile(position: position, target: target, attackDamage: attackDamage)
    }
    
}

class PoisonProjectileFactory: ProjectileFactoryProtocol{
    
    func createProjectile(position: CGPoint, target: Enemy, attackDamage: Int) -> Projectile {
        return PoisonProjectile(position: position, target: target, attackDamage: attackDamage)
    }
    
}

protocol ProjetileCreator{
    
    func createProjectile()
    
}

//this class takes in a type, calls the correct projectile factory and places it in the node.
class ProjectileFactory: ProjetileCreator{
    
    var firingTower: Tower
    
    init(firingTower: Tower){
        self.firingTower = firingTower
    }
    
    func createProjectile() {
        
        switch firingTower.projectileType {
            
        case .gunProjectile:
            
            let projectile = GunProjectileFactory().createProjectile(position: firingTower.position, target: firingTower.currentTarget!, attackDamage: firingTower.attackDamage)
            ProjectileNodes.projectilesNode.addChild(projectile)
            
        case .rapidFireProjectile:
            
            let rapidFireTower = firingTower as! RapidFireTower
            
            let projectile = GunProjectileFactory().createProjectile(position: rapidFireTower.position, target: rapidFireTower.currentTarget!, attackDamage: rapidFireTower.attackDamage)
            
            if rapidFireTower.slowUpgraded{
                //spawn slowbullets here
                let slowProjectile = projectile as! GunProjectile
                
                slowProjectile.isSlowUpgraded = true
            }
            
            if rapidFireTower.fireLeft{
                
//                if rapidFireTower.slowUpgraded{
//                    rapidFireTower.towerTexture.texture = SKTexture(imageNamed: "speed_tower_left_fire_slime")
//                }else{
//                    rapidFireTower.towerTexture.texture = SKTexture(imageNamed: "speed_tower_left_fire")
//                }
                
                projectile.texture = SKTexture(imageNamed: "speed_projectile_left")
                
            }else{
                
//                if rapidFireTower.slowUpgraded{
//                    rapidFireTower.towerTexture.texture = SKTexture(imageNamed: "speed_tower_right_fire_slime")
//                }else{
//                    rapidFireTower.towerTexture.texture = SKTexture(imageNamed: "speed_tower_right_fire")
//                }
                projectile.texture = SKTexture(imageNamed: "speed_projectile_right")
                
            }
            
            rapidFireTower.fireLeft = !rapidFireTower.fireLeft
            ProjectileNodes.projectilesNode.addChild(projectile)
            
        case .sniperProjectile:
            
            let projectile = SniperProjectileFactory().createProjectile(position: firingTower.position, target: firingTower.currentTarget!, attackDamage: firingTower.attackDamage)
            ProjectileNodes.projectilesNode.addChild(projectile)
            
        case .bouncingProjectile:
            
            let projectile = BouncingProjectileFactory().createProjectile(position: firingTower.position, target: firingTower.currentTarget!, attackDamage: firingTower.attackDamage)
            ProjectileNodes.projectilesNode.addChild(projectile)
            
        case .poisonProjectile:
            
            let projectile = PoisonProjectileFactory().createProjectile(position: firingTower.position, target: firingTower.currentTarget!, attackDamage: firingTower.attackDamage)
            ProjectileNodes.projectilesNode.addChild(projectile)
            
        default: print("Error creating projectile")
            
            
        }
        
    }
    
    
    
}
