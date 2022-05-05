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
    var edgesTilesNode: SKNode = SKNode()
    var foundationPlatesNode: SKNode = SKNode()
    var towersNode: SKNode = SKNode()
    var projectilesNode: SKNode = SKNode()
    var gunProjectilesPool = [GunProjectile]()
    var enemiesNode: SKNode = SKNode()
    var enemy: SKNode = SKNode()
    var nodeGraph: GKObstacleGraph? = nil
    
    var rangeIndicator: SKShapeNode?
    
    var isWaveActive: Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMove(to view: SKView) {
        
        GameScene.instance = self
        
        physicsWorld.contactDelegate = self
        
        setupClickableTiles()
        setupEdges()
        addChild(edgesTilesNode)
        setupStartFoundation()
        addChild(towersNode)
        addChild(projectilesNode)
        setupEnemies()
        addChild(enemiesNode)
        
    }
    
    private func setupEdges(){
        
        guard let edgesTileMap = childNode(withName: "edge")as? SKTileMapNode else {
            return
        }
        
        for row in 0..<edgesTileMap.numberOfRows{
            for column in 0..<edgesTileMap.numberOfColumns{
                
                guard let tile = tile(in: edgesTileMap, at: (column, row)) else {continue}
                guard tile.userData?.object(forKey: "isEdge") != nil else {continue}
                
                let edge = Edge()
                
                edge.position = edgesTileMap.centerOfTile(atColumn: column, row: row)
                edgesTilesNode.addChild(edge)
                
            }
        }
        
        edgesTileMap.removeFromParent()
    }
    
    private func setupEnemies(){
        
        
        let enemy1 = StandardEnemy(texture: SKTexture(imageNamed: "Cobblestone_Grid_Center"))
        enemy1.position = CGPoint(x: -64, y: -900)
        enemy1.zPosition = 2
        enemiesNode.addChild(enemy1)
        
        let enemy2 = StandardEnemy(texture: SKTexture(imageNamed: "Cobblestone_Grid_Center"))
        enemy2.position = CGPoint(x: -64, y: -300)
        enemy2.zPosition = 2
        enemiesNode.addChild(enemy2)
        
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
        
        if rangeIndicator != nil{
            rangeIndicator!.removeFromParent()
            
        }
        
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
                    
                }
                if node is Tower{
                    let tower = node as! Tower
                    tower.onClick()
                    displayRangeIndicator(tower: tower)
                    
                }
                
            }
        }
        
    }
    
    func displayRangeIndicator(tower: Tower){
        
        
        rangeIndicator = SKShapeNode(circleOfRadius: tower.attackRange)
        rangeIndicator!.name = "RangeIndicator"
        rangeIndicator!.fillColor = SKColor(.white.opacity(0.2))
        
        rangeIndicator!.zPosition = 2
        rangeIndicator!.position = tower.position
        
        GameScene.instance?.addChild(rangeIndicator!)
        
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
        
        if isWaveActive{
            
            for node in enemiesNode.children{
                
                let enemy = node as! Enemy
                enemy.movePlayerToGoal()
                
            }
            
        }
        
        
    }
    
}

typealias tileCoordinates = (column: Int, row: Int)
