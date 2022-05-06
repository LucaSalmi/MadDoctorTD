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
    var waveManager: WaveManager? = nil
    var spawnCounter = 0
    var waveStartCounter = 0
    
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
        
        //edgesTileMap.removeFromParent()
    }
    
    private func setupEnemies(){
        
        waveManager = WaveManager(totalSlots: WaveData.WAVE_STANDARD_SIZE)

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
        
        foundationPlatesNode.name = "FoundationPlates"
        addChild(foundationPlatesNode)
        
        guard let startFoundationMap = childNode(withName: "start_foundation")as? SKTileMapNode else {
            return
        }
        
        for row in 0..<startFoundationMap.numberOfRows{
            for column in 0..<startFoundationMap.numberOfColumns{
                
                guard let tile = tile(in: startFoundationMap, at: (column, row)) else {continue}
                guard tile.userData?.object(forKey: "isFoundationPlate") != nil else {continue}
                
                let position = startFoundationMap.centerOfTile(atColumn: column, row: row)
                
                for node in clickableTilesNode.children {
                    let clickableTile = node as! ClickableTile
                    if clickableTile.contains(position) {
                        
                        let foundationPlate = FoundationPlate(position: position, tile: clickableTile, isStartingFoundation: true)
                        
                        foundationPlatesNode.addChild(foundationPlate)
                        
                        foundationPlate.updateFoundationsTexture()
                    }
                }
                
            }
        }
        
        for node in foundationPlatesNode.children {
            let foundationPlate = node as! FoundationPlate
            foundationPlate.updateFoundationsTexture()
        }

        startFoundationMap.removeFromParent()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        

        if rangeIndicator != nil{
            rangeIndicator!.removeFromParent()
            
        }

        let communicator = GameSceneCommunicator.instance
        communicator.cancelAllMenus()
        
        guard let touch = touches.first else {return}
        
        let location = touch.location(in: self)
        let touchedNode = self.nodes(at: location)
        
        let node = touchedNode.first
        
        if node is ClickableTile {
            let clickableTile = node as! ClickableTile
            clickableTile.onClick()

        }
        else if node is FoundationPlate {
            let foundationPlate = node as! FoundationPlate
            foundationPlate.onClick()
            
            print("Foundation Plate clicked")
        }
        else if node is Tower{
            let tower = node as! Tower
            tower.onClick()
        }

    }
    

    
    func tile(in tileMap: SKTileMapNode, at coordinates: tileCoordinates) -> SKTileDefinition?{
        return tileMap.tileDefinition(atColumn: coordinates.column, row: coordinates.row)
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        //Update code
        
       timers()
        
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
                enemy.update()
                
            }
            
        }
    }
    
    //Timers for starting the wave and then spawn one enemy from the wave
    func timers(){
        
        if !isWaveActive{
            
            waveStartCounter += 1
            if waveStartCounter >= WaveData.WAVE_START_TIME{
                
                isWaveActive = true
                
            }
            
        }else{
            
            spawnCounter += 1
            
            if spawnCounter >= WaveData.SPAWN_STANDARD_TIMER{
                
                if (waveManager?.enemyArray.count)! > 0{
                    waveManager?.spawnEnemy()
                }
                spawnCounter = 0
            }
        }
    }
    
    
    
}

typealias tileCoordinates = (column: Int, row: Int)
