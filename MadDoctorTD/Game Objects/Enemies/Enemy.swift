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
    
    var baseSpeed = EnemiesData.BASE_SPEED
    var isMoving: Bool = false
    var hp = EnemiesData.BASE_HP
    var movePoints = [CGPoint]()
    var direction: CGPoint = CGPoint(x: 0, y: 0)
    var waveSlotSize = EnemiesData.STANDARD_ENEMY_SLOT
    var enemyType: EnemyTypes = .standard
    var armorValue: Int = 0
    
    var isAttacker = false
    var attackTarget: FoundationPlate? = nil
    var precedentTargetPosition: CGPoint? = nil
    var attackPower: Int = EnemiesData.BASE_ATTACK_POWER_VALUE
    var attackSpeed: Int = EnemiesData.BASE_ATTACK_SPEED_VALUE
    var attackCounter: Int = 0
    
    var progressBar = SKShapeNode()
    var startHp = 0
    
    var killValue = EnemiesData.BASE_KILL_VALUE
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    init(texture: SKTexture, color: UIColor){
        
        let tempColor = UIColor(.indigo)
        super.init(texture: texture, color: tempColor, size: EnemiesData.SIZE)
        physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
        physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        physicsBody?.restitution = 0
        physicsBody?.allowsRotation = false
        
        self.name = "Enemy"
        progressBar = SKShapeNode(rectOf: CGSize(width: hp, height: 10))
        
        progressBar.fillColor = .cyan

    }
    
    
    func update(){
        
        if !isMoving {
            movePoints = GameScene.instance!.pathfindingTestEnemy!.movePoints
            isMoving = true
        }
                
        if self.enemyType == .flying || self.isAttacker{
            
            if movePoints.count > 1 {
                let finalPoint = movePoints[movePoints.count-1]
                movePoints = [finalPoint]
            }
        }
        
        if progressBar.parent != nil{
            progressBar.removeFromParent()
        }
        
        progressBar = SKShapeNode(rectOf: CGSize(width: hp, height: 20))
        progressBar.fillColor = .cyan
        progressBar.position = CGPoint(x: self.position.x, y: self.position.y + 30)
        GameScene.instance?.addChild(progressBar)
        
        if movePoints.isEmpty {
            return
        }
        
        move()
        
    }
    
    private func move() {
        
        if isAttacker {
            
            if attackTarget != nil{
                
                attack()
                return
                
            }else{
                
                let targetPosition = findNextTarget()
                if targetPosition != nil{
                    
                    setDirection(targetPoint: targetPosition!)
                    position.x += direction.x * baseSpeed
                    position.y += direction.y * baseSpeed
                    return
                }
            }
        }
        
        let nextPoint = movePoints[0]
        
        setDirection(targetPoint: nextPoint)
        
        position.x += direction.x * baseSpeed
        position.y += direction.y * baseSpeed
        
        if hasReachedPoint(point: nextPoint) {
            movePoints.remove(at: 0)
        }
    }
    
    
    private func attack(){
        
        if attackCounter >= attackSpeed{
            
            attackCounter = 0
            
            if attackTarget!.onDestroy(damageIn: self.attackPower){
                
                attackTarget = nil
                
            }
            
        }else{
            
            attackCounter += 1
            
        }
    }
    
    
    private func findNextTarget() -> CGPoint?{
        
        if precedentTargetPosition != nil{
            
            for node in FoundationPlateNodes.foundationPlatesNode.children{
                
                if precedentTargetPosition!.x + 86 == node.position.x || precedentTargetPosition!.x - 86 == node.position.x {
                    
                    return node.position
                    
                }
            }
        }
        
        
        return nil
    }
    
    
    private func setDirection(targetPoint: CGPoint) {
        
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
    
    func getDamage(dmgValue: Int){
        
        hp -= (dmgValue - armorValue)
        
        if hp <= 0{
            
            GameManager.instance.currentMoney += self.killValue
            print("KILL VALUE = \(GameManager.instance.currentMoney)")
            progressBar.removeFromParent()
            self.removeFromParent()
            print("Current enemy wave count = \(EnemyNodes.enemiesNode.children.count)")
            SoundManager.playSFX(sfxName: SoundManager.slimeDeathSFX )
        }
        
    }
    
    private func hasReachedPoint(point: CGPoint) -> Bool {
        
        //create a rect with edges:
        let leftEdge: CGFloat = position.x - (size.width/4)
        let rightEdge: CGFloat = position.x + (size.width/4)
        let bottomEdge: CGFloat = position.y - (size.height/4)
        let topEdge: CGFloat = position.y + (size.height/4)
        
        if point.x > leftEdge && point.x < rightEdge {
            if point.y > bottomEdge && point.y < topEdge {
                return true
            }
        }
        
        return false
    }
    
    
    func getMovePoints() -> [CGPoint] {
        
        var newMovePoints = [CGPoint]()
        
        let gameScene = GameScene.instance!
        
        // Find the player in the scene.
        
        let player = self
        let goal = GameScene.instance!.childNode(withName: "goal")
        
        // Create an array of obstacles, which is every child node, apart from the player node.
        var obstacles = SKNode.obstacles(fromNodeBounds: FoundationPlateNodes.foundationPlatesNode.children.filter({ (element ) -> Bool in
            return element != player
        }))
        let edges = SKNode.obstacles(fromNodeBounds: gameScene.edgesTilesNode.children)
        obstacles.append(contentsOf: edges)
        
        // Assemble a graph based on the obstacles. Provide a buffer radius so there is a bit of space between the
        // center of the player node and the edges of the obstacles.
        let graph = GKObstacleGraph(obstacles: obstacles, bufferRadius: Float(Float(EnemiesData.SIZE.width)*0.8))
        
        // Create a node for the user's current position, and the user's destination.
        let startNode = GKGraphNode2D(point: SIMD2<Float>(Float(player.position.x), Float(player.position.y)))
        let endNode = GKGraphNode2D(point: SIMD2<Float>(Float(goal!.position.x), Float(goal!.position.y)))
        
        // Connect the two nodes just created to graph.
        graph.connectUsingObstacles(node: startNode)
        graph.connectUsingObstacles(node: endNode)
        
        // Find a path from the start node to the end node using the graph.
        let path:[GKGraphNode] = graph.findPath(from: startNode, to: endNode)
        
        // If the path has 0 nodes, then a path could not be found, so return.
        guard path.count > 0 else { print("Error: Path array is empty. No clear path found!"); return newMovePoints }
        
        // Create an array of actions that the player node can use to follow the path.
        //var actions = [SKAction]()
        
        for node:GKGraphNode in path {
            if let point2d = node as? GKGraphNode2D {
                let nextPoint = CGPoint(x: CGFloat(point2d.position.x), y: CGFloat(point2d.position.y))
                //print("Player pos = \(player.position). Next point = \(nextPoint)")
                if player.position == nextPoint {
                    continue
                }
                //                var duration = getDuration(pointA: player.position, pointB: nextPoint, speed: baseSpeed)
                //                if duration <= 0.0 {
                //                    duration = 0.1
                //                }
                //                print("Duration = \(duration)")
                //                let action = SKAction.move(to: nextPoint, duration: duration)
                //                actions.append(action)
                
                newMovePoints.append(nextPoint)
            }
        }
        
        //        // Convert those actions into a sequence action, then run it on the player node.
        //        let sequence = SKAction.sequence(actions)
        //        player.run(sequence, completion: { () -> Void in
        //            // When the action completes, allow the player to move again.
        //            self.moving = false
        //        })
        
        return newMovePoints
    }

    
    
}
