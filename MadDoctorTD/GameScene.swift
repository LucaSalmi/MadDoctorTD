//
//  GameScene.swift
//  MadDoctorTD
//
//  Created by Daniel Falkedal on 2022-05-03.
//

import Foundation
import GameplayKit
import SpriteKit
import SwiftUI

class GameScene: SKScene {
    
    static var instance: GameScene? = nil
    
    var clickableTilesNode: SKNode = SKNode()
    var foundationPlatesNode: SKNode = SKNode()
    var towersNode: SKNode = SKNode()
    var projectilesNode: SKNode = SKNode()
    var enemiesNode: SKNode = SKNode()
    var enemy: SKNode = SKNode()
    var nodeGraph: GKObstacleGraph? = nil
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMove(to view: SKView) {
        
        GameScene.instance = self
        
        physicsWorld.contactDelegate = self
        
        setupClickableTiles()
        setupStartFoundation()
        addChild(towersNode)
        addChild(projectilesNode)
        setupEnemies()
        
        enemy = Enemy(texture: SKTexture(imageNamed: "Cobblestone_Grid_Center"), color: .clear)
        let obstacles = SKNode.obstacles(fromNodePhysicsBodies: foundationPlatesNode.children)
        nodeGraph = GKObstacleGraph(obstacles: obstacles, bufferRadius: 0.0)
        let start = GKGraphNode()
        enemy.position = clickableTilesNode.children[34].position
        enemy.zPosition = 2
        addChild(enemy)
        
    }
    
    private func setupEnemies(){
        
        
        let enemy1 = Enemy(texture: SKTexture(imageNamed: "Cobblestone_Grid_Center"), color: .clear)
        enemy1.position = CGPoint(x: -64, y: -600)
        enemy1.zPosition = 2
        enemiesNode.addChild(enemy1)
        
        let enemy2 = Enemy(texture: SKTexture(imageNamed: "Cobblestone_Grid_Center"), color: .clear)
        enemy2.position = CGPoint(x: -64, y: -1000)
        enemy2.zPosition = 2
        enemiesNode.addChild(enemy2)
        
        addChild(enemiesNode)
    }
    
    private func setupClickableTiles() {
        
        guard let clickableTileMap = childNode(withName: "clickable_tiles")as? SKTileMapNode else {
            return
        }
        
        for row in 0..<clickableTileMap.numberOfRows{
            for column in 0..<clickableTileMap.numberOfColumns{
                
                guard let tile = tile(in: clickableTileMap, at: (column, row)) else {continue}
                guard tile.userData?.object(forKey: "isClickableTile") != nil else {continue}
                
                
                
                let clickableTile = ClickableTile(position: clickableTileMap.centerOfTile(atColumn: column, row: row))
                
                clickableTilesNode.addChild(clickableTile)
                
        
                
                
            }
        }
        
        clickableTilesNode.name = "ClickableTiles"
        addChild(clickableTilesNode)
        clickableTileMap.removeFromParent()
        
    }
    
    private func setupStartFoundation() {
        
        let clickableTile1 = clickableTilesNode.children[55] as! ClickableTile
        clickableTile1.containsFoundation = true
        
        let foundationPlate1 = FoundationPlate(position: clickableTile1.position, tile: clickableTile1)
        foundationPlatesNode.addChild(foundationPlate1)
        
        addChild(foundationPlatesNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                if node is ClickableTile {
                    let clickableTile = node as! ClickableTile
                    clickableTile.onClick()
                }
                if node is FoundationPlate {
                    let foundationPlate = node as! FoundationPlate
                    foundationPlate.onClick()
                    
                    print("Foundation Plate clicked")
                }
                if node is Tower{
                    let tower = node as! Tower
                    tower.onClick()
                }
            }
        }
        
    }
    
    func tile(in tileMap: SKTileMapNode, at coordinates: tileCoordinates) -> SKTileDefinition?{
        return tileMap.tileDefinition(atColumn: coordinates.column, row: coordinates.row)
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        //Update code
        
        for node in towersNode.children {
            let tower = node as! Tower
            tower.update()
        }
        
        for node in projectilesNode.children {
            let projectile = node as! Projectile
            projectile.update()
        }
        
        
        for node in enemiesNode.children {
            let enemy = node as! Enemy
            enemy.update()
        }
        
    }
    
}

typealias tileCoordinates = (column: Int, row: Int)