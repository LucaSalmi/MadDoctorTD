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
    
    
    var edgesTilesNode: SKNode = SKNode()
    var foundationPlatesNode: SKNode = SKNode()
    var enemiesNode: SKNode = SKNode()
    var pathfindingTestEnemy: Enemy?
    var nodeGraph: GKObstacleGraph? = nil
    var waveManager: WaveManager? = nil
    var spawnCounter = 0
    var waveStartCounter = 0
    
    var rangeIndicator: SKShapeNode?
    
    var isWaveActive: Bool = false
    var wavesCompleted = 0
    var enemyChoises = [EnemyTypes]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMove(to view: SKView) {
        
        GameScene.instance = self
        physicsWorld.contactDelegate = self
        
        let _ = ClickableTileFactory()
        addChild(ClickableTilesNodes.clickableTilesNode)
        
        setupEdges()
        addChild(edgesTilesNode)
        
        setupStartFoundation()
        
        //add towerNode and towerTextureNode to GameScene
        addChild(TowerNode.towersNode)
        addChild(TowerNode.towerTextureNode)
        
        //add ProjectilesNote to GameScene
        addChild(ProjectileNodes.projectilesNode)
        
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
        
        //build phase pathfinding test
        pathfindingTestEnemy = StandardEnemy(texture: SKTexture(imageNamed: "joystick"))
        let spawnPoint = childNode(withName: "SpawnPoint")
        pathfindingTestEnemy!.position = spawnPoint!.position
        addChild(pathfindingTestEnemy!)
        
        enemyChoises.append(.standard)
        enemyChoises.append(.flying)
        
        waveManager = WaveManager(totalSlots: WaveData.WAVE_STANDARD_SIZE, choises: enemyChoises)

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
                
                for node in ClickableTilesNodes.clickableTilesNode.children {
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
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if GameManager.instance.isPaused {
            return
        }
        
        touchesBegan(touches, with: event)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if GameManager.instance.isPaused {
            return
        }

        if rangeIndicator != nil{
            rangeIndicator!.removeFromParent()
            
        }

        let communicator = GameSceneCommunicator.instance
        communicator.cancelAllMenus()
        
        guard let touch = touches.first else {return}
        
        //let location = touch.location(in: self)
        //let touchedNode = self.nodes(at: location)
        
        //guard let node = touchedNode.first else {return}
        
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        for node in touchedNodes {
            
            if node is Tower{
                let tower = node as! Tower
                tower.onClick()
                break
            }
            else if node is FoundationPlate {
                let foundationPlate = node as! FoundationPlate
                foundationPlate.onClick()
                break
            }
            else if node is ClickableTile {
                let clickableTile = node as! ClickableTile
                clickableTile.onClick()
                break
            }
        }
    }
    

    
    func tile(in tileMap: SKTileMapNode, at coordinates: tileCoordinates) -> SKTileDefinition?{
        return tileMap.tileDefinition(atColumn: coordinates.column, row: coordinates.row)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        //Update code
        if GameManager.instance.isPaused {
            return
        }
        
       timers()
        
        for node in TowerNode.towersNode.children {
            let tower = node as! Tower
            tower.update()
        }
        

        for node in ProjectileNodes.projectilesNode.children {
            if node is Projectile{
                let projectile = node as! Projectile
                projectile.update()
            }
            else{
                let aoeProjectile = node as! AoeProjectile
                aoeProjectile.update()
            }
            
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
            GameManager.instance.nextWaveCounter = waveStartCounter
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
            
            waveManager!.update()
        }
    }
    
    
    func progressDifficulty(){
        
        if wavesCompleted == 5{
            enemyChoises.append(.heavy)
            waveManager?.totalSlots += 5
        }else if wavesCompleted == 10{
            enemyChoises.append(.flying)
            waveManager?.totalSlots += 10
        }else if wavesCompleted == 15{
            waveManager?.totalSlots += 15
        }
    }
    
    
    
}

typealias tileCoordinates = (column: Int, row: Int)
