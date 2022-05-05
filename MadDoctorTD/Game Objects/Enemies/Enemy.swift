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
    var moving: Bool = false
    var hp = EnemiesData.BASE_HP
    var movePoints = [CGPoint]()
    let goal = GameScene.instance!.childNode(withName: "goal")
    var direction: CGPoint = CGPoint(x: 0, y: 0)
    var waveSlotSize = EnemiesData.STANDARD_ENEMY_SLOT

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    init(texture: SKTexture, color: UIColor){
        
        let tempColor = UIColor(.indigo)
        super.init(texture: texture, color: tempColor, size: EnemiesData.SIZE)
        physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
        physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        physicsBody?.collisionBitMask = PhysicsCategory.Foundation
        physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        physicsBody?.restitution = 0
        physicsBody?.allowsRotation = false
        
        self.name = "Enemy"
        
    }
    
    func update(){
        
        //self.position = CGPoint(x: self.position.x, y: self.position.y + CGFloat(baseSpeed))
        
        if !self.moving {
            let _ = movePlayerToGoal()
            return
        }
        
        if movePoints.isEmpty {
            return
        }
        
        move()
        
    }
    
    private func move() {
        
        let nextPoint = movePoints[0]
        
        setDirection(targetPoint: nextPoint)
        
        position.x += direction.x * baseSpeed
        position.y += direction.y * baseSpeed
        
        if hasReachedPoint(point: nextPoint) {
            movePoints.remove(at: 0)
        }
        
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
        
        hp -= dmgValue
        
        if hp <= 0{
            
            self.removeFromParent()
            
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
    
    
    func movePlayerToGoal() -> [CGPoint] {
        
        var newMovePoints = [CGPoint]()
        
        let gameScene = GameScene.instance!
        
        // Ensure the player doesn't move when they are already moving.
        guard (!moving) else {return newMovePoints}
        
        // Find the player in the scene.
        
        let player = self
        
        // Create an array of obstacles, which is every child node, apart from the player node.
        var obstacles = SKNode.obstacles(fromNodeBounds: gameScene.foundationPlatesNode.children.filter({ (element ) -> Bool in
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
        guard path.count > 0 else { moving = false; print("Error: Path array is empty. No clear path found!"); return newMovePoints }
        
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
        
        self.movePoints = newMovePoints
        self.moving = true
        
//        // Convert those actions into a sequence action, then run it on the player node.
//        let sequence = SKAction.sequence(actions)
//        player.run(sequence, completion: { () -> Void in
//            // When the action completes, allow the player to move again.
//            self.moving = false
//        })
        
        return newMovePoints
    }
    
//    private func getDuration(pointA:CGPoint,pointB:CGPoint,speed:CGFloat)->TimeInterval {
//        let xDist = abs(pointA.x - pointB.x)
//        let yDist = abs(pointA.y - pointB.y)
//        let distance = sqrt((xDist * xDist) + (yDist * yDist));
//
//        let duration : TimeInterval = TimeInterval(distance/speed)
//        return duration
//    }
    
}