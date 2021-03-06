//
//  PhysicsExtension.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-03.
//

import Foundation
import SpriteKit

extension GameScene: SKPhysicsContactDelegate{
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        
        if nodeA is Projectile && nodeB is Enemy {
            let projectile = nodeA as! Projectile
            let enemy = nodeB as! Enemy
            enemy.getDamage(dmgValue: projectile.attackDamage, projectile: projectile)
            
            projectile.destroy()
            
        }
        if nodeB is Projectile && nodeA is Enemy {
            let projectile = nodeB as! Projectile
            let enemy = nodeA as! Enemy
            enemy.getDamage(dmgValue: projectile.attackDamage, projectile: projectile)
            projectile.destroy()
        }
        
        
        if nodeA is Enemy && nodeB is FoundationPlate {
            
            let enemy = nodeA as! Enemy
            let foundation = nodeB as! FoundationPlate
            
            enemy.precedentTargetPosition = nil
            
            enemy.attackTarget = foundation
            
            if enemy.precedentTargetPosition == nil{
                enemy.precedentTargetPosition = foundation.position
            }
            
        }
        if nodeA is FoundationPlate && nodeB is Enemy{
            
            let enemy = nodeB as! Enemy
            let foundation = nodeA as! FoundationPlate
            
            enemy.precedentTargetPosition = nil
            
            enemy.attackTarget = foundation
            
            if enemy.precedentTargetPosition == nil{
                enemy.precedentTargetPosition = foundation.position
            }
            
        }
        
        if nodeA is Boss && nodeB is FoundationPlate {
            
            let boss = nodeA as! Boss
            let foundation = nodeB as! FoundationPlate
                        
            boss.attackTarget = foundation
            
        }
        if nodeA is FoundationPlate && nodeB is Boss{
            
            let boss = nodeB as! Boss
            let foundation = nodeA as! FoundationPlate
            
            boss.attackTarget = foundation
                    
        }
        
    }
}


extension CGPoint {

    /**
    Calculates a distance to the given point.

    :param: point - the point to calculate a distance to

    :returns: distance between current and the given points
    */
    func distance(point: CGPoint) -> CGFloat {
        let dx = self.x - point.x
        let dy = self.y - point.y
        return sqrt(dx * dx + dy * dy);
    }
}
