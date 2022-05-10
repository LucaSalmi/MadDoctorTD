//
//  BulletFactory.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-10.
//

import Foundation
import SpriteKit

struct ProjectileNodes{
    
    static var projectilesNode: SKNode = SKNode()
    static var gunProjectilesPool = [GunProjectile]()

}

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

protocol ProjetileCreator{
    
    func createProjectile()
    
}


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
            
            if rapidFireTower.fireLeft{
                
                rapidFireTower.towerTexture.texture = SKTexture(imageNamed: "speed_tower_power_on_left_barrel_fire")
                projectile.texture = SKTexture(imageNamed: "speed_projectile_left")
                
            }else{
                
                rapidFireTower.towerTexture.texture = SKTexture(imageNamed: "speed_tower_power_on_right_barrel_fire")
                projectile.texture = SKTexture(imageNamed: "speed_projectile_right")
                
            }
            
            rapidFireTower.fireLeft = !rapidFireTower.fireLeft
            ProjectileNodes.projectilesNode.addChild(projectile)
            
        case .sniperProjectile:
            
            let projectile = SniperProjectileFactory().createProjectile(position: firingTower.position, target: firingTower.currentTarget!, attackDamage: firingTower.attackDamage)
            ProjectileNodes.projectilesNode.addChild(projectile)
        }
        
    }
    
    
    
}