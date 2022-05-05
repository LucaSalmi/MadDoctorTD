//
//  Player.swift
//  MadDoctorTD
//
//  Created by Daniel Falkedal on 2022-05-04.
//

import Foundation
import SpriteKit
import GameplayKit

class PlayerPathfinding {
    var moving: Bool = false
    
    func movePlayerToGoal() {
        
        let gameScene = GameScene.instance!
        
        // Ensure the player doesn't move when they are already moving.
        guard (!moving) else {return}
        moving = true
        
        // Find the player in the scene.
        let player = gameScene.childNode(withName: "player")
        let goal = gameScene.childNode(withName: "goal")
        
        // Create an array of obstacles, which is every child node, apart from the player node.
        let obstacles = SKNode.obstacles(fromNodeBounds: gameScene.foundationPlatesNode.children.filter({ (element ) -> Bool in
            return element != player
        }))
        
        // Assemble a graph based on the obstacles. Provide a buffer radius so there is a bit of space between the
        // center of the player node and the edges of the obstacles.
        let graph = GKObstacleGraph(obstacles: obstacles, bufferRadius: 36)
        
        // Create a node for the user's current position, and the user's destination.
        let startNode = GKGraphNode2D(point: SIMD2<Float>(Float(player!.position.x), Float(player!.position.y)))
        let endNode = GKGraphNode2D(point: SIMD2<Float>(Float(goal!.position.x), Float(goal!.position.y)))
        
        // Connect the two nodes just created to graph.
        graph.connectUsingObstacles(node: startNode)
        graph.connectUsingObstacles(node: endNode)
        
        // Find a path from the start node to the end node using the graph.
        let path:[GKGraphNode] = graph.findPath(from: startNode, to: endNode)
        
        // If the path has 0 nodes, then a path could not be found, so return.
        guard path.count > 0 else { moving = false; print("Error: Path array is empty. No clear path found!"); return }
        
        // Create an array of actions that the player node can use to follow the path.
        var actions = [SKAction]()
        
        for node:GKGraphNode in path {
            if let point2d = node as? GKGraphNode2D {
                let nextPoint = CGPoint(x: CGFloat(point2d.position.x), y: CGFloat(point2d.position.y))
                let speed = CGFloat(300.0)
                print("Player pos = \(player!.position). Next point = \(nextPoint)")
                if player!.position == nextPoint {
                    continue
                }
                var duration = getDuration(pointA: player!.position, pointB: nextPoint, speed: speed)
                if duration <= 0.0 {
                    duration = 0.1
                }
                print("Duration = \(duration)")
                let action = SKAction.move(to: nextPoint, duration: duration)
                actions.append(action)
            }
        }
        
        // Convert those actions into a sequence action, then run it on the player node.
        let sequence = SKAction.sequence(actions)
        player!.run(sequence, completion: { () -> Void in
            // When the action completes, allow the player to move again.
            self.moving = false
        })
    }
    
    private func getDuration(pointA:CGPoint,pointB:CGPoint,speed:CGFloat)->TimeInterval {
        let xDist = abs(pointA.x - pointB.x)
        let yDist = abs(pointA.y - pointB.y)
        let distance = sqrt((xDist * xDist) + (yDist * yDist));

        let duration : TimeInterval = TimeInterval(distance/speed)
        return duration
    }
}
