//
//  Projectile.swift
//  MadDoctorTD
//
//  Created by Daniel Falkedal on 2022-05-04.
//

import Foundation
import SpriteKit
//Parent class for cannon/mine bullet, creates an Area Of Effect when it hits the ground or an enemy that damages around itself
class AoeProjectile: SKSpriteNode {
    
    let maxTick = 5
    var currentTick = 0
    
    var targetPoint: CGPoint
    var attackDamage: Int
    
    var direction: CGPoint = CGPoint(x: 0, y: 0)
    
    var travelDuration = AoeProjectileData.TRAVEL_DURATION
    var currentDuration = CGFloat(0)
    
    var startPosition: CGPoint
    var blastRadius: CGFloat = AoeProjectileData.BLAST_RADIUS
    
    var projectileShadow: SKSpriteNode
    
    var sizeDifference: CGFloat = 30.0
    
    var invisDuration = 20
    var invisTick = 0
    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    init(position: CGPoint, target: Enemy, attackDamage: Int){
        
        targetPoint = target.position
        self.attackDamage = attackDamage
        startPosition = position
        projectileShadow = SKSpriteNode(texture: SKTexture(imageNamed: "canon_shadow"), color: .clear, size: ProjectileData.CANNON_BALL_SIZE)
        
        projectileShadow.size.width += sizeDifference
        projectileShadow.size.height += sizeDifference
        
        projectileShadow.alpha = 0
        
        GameScene.instance!.uiManager!.projectileShadowNode.addChild(projectileShadow)
        
        super.init(texture: nil, color: .clear, size: ProjectileData.CANNON_BALL_SIZE)
        
        
        
        name = "AoeProjectile"
        self.position = position
        zPosition = 51
        speed = ProjectileData.speed
        
        
        lookAtTarget(target: target)
        
        setDirection()
        
        currentTick = maxTick
        
        speed = self.position.distance(point: targetPoint) / travelDuration
        
        self.alpha = 0
        
        
        
    }
    
    func reuseFromPool(position: CGPoint, target: Enemy, attackDamage: Int) {
        self.attackDamage = attackDamage
        targetPoint = target.position
        self.position = position
        startPosition = position
        lookAtTarget(target: target)
        setDirection()
        currentTick = maxTick
        speed = self.position.distance(point: targetPoint) / travelDuration
        
    }
    
    
    func lookAtTarget(target: Enemy) {
        let lookAtConstraint = SKConstraint.orient(to: target,
                                    offset: SKRange(constantValue: -CGFloat.pi / 2))
        self.constraints = [ lookAtConstraint ]
    }
    
    func setDirection() {
        
        var differenceX = targetPoint.x - self.position.x
        var differenceY = targetPoint.y - self.position.y
        
        var isNegativeX = false
        if differenceX < 0 {
            isNegativeX = true
            differenceX *= -1
        }
        
        var isNegativeY = false
        if differenceY < 0 {
            isNegativeY = true
            differenceY *= -1
        }
        
        let differenceH = sqrt((differenceX*differenceX) + (differenceY*differenceY))
        
        differenceX /= differenceH
        differenceY /= differenceH
        
        if isNegativeX {
            differenceX *= -1
        }
        if isNegativeY {
            differenceY *= -1
        }
        
        direction.x = differenceX
        direction.y = differenceY
        
        
    }
    
    func hasReachedTargetPoint() -> Bool{
        
        let leftSide = targetPoint.x - self.size.width/4
        let rightSide = targetPoint.x + self.size.width/4
        
        let topSide = targetPoint.y + self.size.height/4
        let botSide = targetPoint.y - self.size.height/4
        
        if self.position.x > leftSide && self.position.x < rightSide{
            if self.position.y > botSide && self.position.y < topSide{
                return true
            }
        }
        
        return false
    }
    
    func destroy() {
        //OVERRIDE THIS IN SUBCLASSES!
        projectileShadow.removeFromParent()
        
    }
    
    func findEnemiesInRadius(radius: CGFloat) -> [Enemy]{
        var enemies = [Enemy]()
        
        
        let enemyNode = EnemyNodes.enemiesNode
        
        for node in enemyNode.children{
            let enemy = node as! Enemy
            
            let enemyDistance = self.position.distance(point: enemy.position)
            
            if enemyDistance <= radius{
                enemies.append(enemy)
            }
            
            
        }
        
        
        return enemies
        
    }
    

    func update() {
        
        if invisTick < invisDuration{
            invisTick += 1
        }
        else{
            if self.alpha != 1{
                self.alpha = 1
                projectileShadow.alpha = 0.8
            }
        }
        
        if currentTick > 0 {
            currentTick -= 1
        }
        else {
            self.constraints = []
        }
        
        self.position.x += (direction.x * speed)
        self.position.y += (direction.y * speed)
        
        projectileShadow.position = self.position
        
        
        currentDuration += 1
        
        
        
        if currentDuration < (travelDuration/2){
            self.size.width += 0.5
            self.size.height += 0.5
            
            projectileShadow.alpha -= 0.005
            
            
        }
        else{
            self.size.width -= 0.5
            self.size.height -= 0.5
            

            projectileShadow.alpha += 0.005
        }
        
        
        if hasReachedTargetPoint(){
            self.destroy()
            
        }
        
        guard let worldEdge = GameScene.instance!.childNode(withName: "superBackground") else {return}
        
        if position.x > worldEdge.frame.size.width / 2 || position.x < (worldEdge.frame.size.width / 2) * -1 ||
            position.y > worldEdge.frame.size.height / 2 || position.y < (worldEdge.frame.size.height / 2) * -1
        {
            destroy()
        }
    }
    
}

