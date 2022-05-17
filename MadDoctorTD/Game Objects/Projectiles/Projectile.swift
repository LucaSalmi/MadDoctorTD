//
//  Projectile.swift
//  MadDoctorTD
//
//  Created by Daniel Falkedal on 2022-05-04.
//

import Foundation
import SpriteKit

class Projectile: SKSpriteNode {
    
    let maxTick = 5
    var currentTick = 0
    
    var targetPoint: CGPoint
    var attackDamage: Int
    
    var direction: CGPoint = CGPoint(x: 0, y: 0)

    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    init(position: CGPoint, target: Enemy, attackDamage: Int){
        
        targetPoint = target.position
        self.attackDamage = attackDamage
        
        super.init(texture: nil, color: .clear, size: ProjectileData.size)
        
        name = "Projectile"
        self.position = position
        zPosition = 2
        speed = ProjectileData.speed
        
        setupPhysicsBody()
        
        lookAtTarget(target: target)
        
        setDirection()
        
        currentTick = maxTick
        
    }
    
    func reuseFromPool(position: CGPoint, target: Enemy, attackDamage: Int) {
        self.attackDamage = attackDamage
        targetPoint = target.position
        self.position = position
        lookAtTarget(target: target)
        setDirection()
        currentTick = maxTick
        
    }
    
    private func setupPhysicsBody() {
        
        physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
        physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        physicsBody?.restitution = 0
        physicsBody?.isDynamic = true
        physicsBody?.friction = 0
        physicsBody?.allowsRotation = false
        
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
    
    func destroy() {
        //OVERRIDE THIS IN SUBCLASSES!
    }

    func update() {
        
        if currentTick > 0 {
            currentTick -= 1
        }
        else {
            self.constraints = []
        }
        
        self.position.x += (direction.x * speed)
        self.position.y += (direction.y * speed)
        
        guard let worldEdge = GameScene.instance!.childNode(withName: "superBackground") else {return}
        
        if position.x > worldEdge.frame.size.width / 2 || position.x < (worldEdge.frame.size.width / 2) * -1 ||
            position.y > worldEdge.frame.size.height / 2 || position.y < (worldEdge.frame.size.height / 2) * -1
        {
            destroy()
            print("bullet removed")
        }
    }
    
}
