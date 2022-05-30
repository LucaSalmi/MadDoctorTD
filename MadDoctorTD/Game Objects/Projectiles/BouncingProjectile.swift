//
//  BouncingProjectile.swift
//  MadDoctorTD
//
//  Created by Daniel Falkedal on 2022-05-24.
//

import Foundation
import SpriteKit

class BouncingProjectile: GunProjectile {
    
    var previuousTargets = [Enemy]()
    let numberOfBounces: Int = 2
    let dmgReductionPerBounce: CGFloat = 0.33
    let bounceRange: CGFloat = 300
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    override init(position: CGPoint, target: Enemy, attackDamage: Int){
        
        super.init(position: position, target: target, attackDamage: attackDamage)
        
        texture = SKTexture(imageNamed: "bounce_projectile")

        //This projectile sub-class uses different collison logic
        physicsBody?.contactTestBitMask = 0
        physicsBody = nil
        
        speed = ProjectileData.BOUNCING_PROJECTILE_SPEED
    }
    
    private func findNewTarget() -> Enemy? {
        
        let enemies = EnemyNodes.enemiesNode.children
        
        var closestDistance = CGFloat(bounceRange+1)
        
        var closestEnemy: Enemy? = nil
        
        for node in enemies {
            
            let enemy = node as! Enemy
            
            if previuousTargets.contains(enemy) {
                continue
            }
            
            let enemyDistance = position.distance(point: enemy.position)
            
            if enemyDistance < closestDistance {
                closestDistance = enemyDistance
                if enemyDistance <= bounceRange {
                    closestEnemy = enemy
                }
            }
        }
        
        return closestEnemy
    }
    
    private func checkCollision() -> Enemy? {
        
        for node in EnemyNodes.enemiesNode.children {
            let enemy = node as! Enemy
            
            if enemy.contains(self.position) && !previuousTargets.contains(enemy) {
                
                return enemy
                
            }
        }
        
        return nil
    }
    
    override func destroy() {
        
        SoundManager.playMetalTapSFX(scene: GameScene.instance!)
        
        self.removeFromParent()
        
    }
    
    override func update() {
        
//        let spinPct = CGFloat.pi / 4
//        zRotation += spinPct
        
        super.update()
        
        //Check collision with enemy
        guard let enemy = checkCollision() else {
            return
        }
        
        enemy.getDamage(dmgValue: self.attackDamage)
        previuousTargets.append(enemy)
        
        //Reduce dmg for next/future impact
        self.attackDamage -= Int(CGFloat(self.attackDamage) * dmgReductionPerBounce)
        
        //Destroy projectile if no bounces left
        if previuousTargets.count > numberOfBounces {
            self.destroy()
            return
        }
        
        //Destroy projectile if no new unique target was found
        guard let newTarget = findNewTarget() else {
            self.destroy()
            return
        }
        
        //Set new target
        targetPoint = newTarget.position
        setDirection()
        
    }
    
}
