//
//  Enemy.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-04.
//

import Foundation
import SpriteKit
import GameplayKit

class Enemy: SKSpriteNode{
    
    var pathfindingAgent: EnemyEntity? = nil
    var baseHp = EnemiesData.baseHP
    var baseSpeed = EnemiesData.baseSpeed
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    init(texture: SKTexture, color: UIColor){
        
        let tempColor = UIColor(.indigo)
        super.init(texture: texture, color: tempColor, size: EnemiesData.size)
        physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
        physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        physicsBody?.collisionBitMask = PhysicsCategory.Foundation
        physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        physicsBody?.restitution = 0
        physicsBody?.allowsRotation = false
        
        self.name = "Enemy"
        
    }
    
    func update(){
        
        self.position = CGPoint(x: self.position.x, y: self.position.y + CGFloat(baseSpeed))
        
        
    }
    
    func getDamage(dmgValue: Int){}
    
}

class EnemyAgent: GKAgent2D{
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    override init(){
        super.init()
        speed = Float(EnemiesData.baseSpeed)
        let goal = GKGoal(toWander: 100)
        behavior = GKBehavior(goal: goal, weight: 100)
    }
    
}

class EnemyEntity: GKEntity{
    
    let sprite: SKShapeNode
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    override init() {
        
        sprite = SKShapeNode(circleOfRadius: 20)
        sprite.fillColor = .blue
        sprite.zRotation = CGFloat(GKRandomDistribution(lowestValue: 0, highestValue: 360).nextInt())
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: EnemiesData.size.width/2)
        sprite.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        sprite.physicsBody?.collisionBitMask = PhysicsCategory.Foundation
        sprite.physicsBody?.restitution = 0
        sprite.physicsBody?.allowsRotation = false


        super.init()
        
        let agent = EnemyAgent()
        addComponent(agent)
        let node = GKSKNodeComponent(node: sprite)
        addComponent(node)
        agent.delegate = node

    }
}



