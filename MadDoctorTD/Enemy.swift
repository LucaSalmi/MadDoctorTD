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
        let entity = EnemyEntity()
        pathfindingAgent = entity
        
        self.name = "Enemy"
        
    }
    
    func update(){
        
        //self.position = CGPoint(x: self.position.x, y: self.position.y + EnemiesData.baseSpeed)
        
        
    }
    
    func getPathfinder() -> EnemyEntity{
        
        if pathfindingAgent != nil{
            
            return pathfindingAgent!
            
        }else{
            
            return EnemyEntity()
            
        }
        
    }
}

class EnemyAgent: GKAgent2D{
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    override init(){
        super.init()
        speed = EnemiesData.baseSpeed
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



