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
    
    var pathfindingTestEnemy: Enemy?
    var nodeGraph: GKObstacleGraph? = nil
    var waveManager: WaveManager? = nil
    
    var rangeIndicator: SKShapeNode?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMove(to view: SKView) {
        
        if GameScene.instance != nil {
            return
        }
        
        GameScene.instance = self
        physicsWorld.contactDelegate = self
        
        //creates and adds clickable tiles to GameScene
        let _ = ClickableTileFactory()
        addChild(ClickableTilesNodes.clickableTilesNode)
        
        setupEdges()
        addChild(edgesTilesNode)
        
        //creates start foundations and adds the node to the GameScene
        FoundationPlateFactory().setupStartPlates()
        addChild(FoundationPlateNodes.foundationPlatesNode)
        
        //add towerNode and towerTextureNode to GameScene
        addChild(TowerNode.towersNode)
        addChild(TowerNode.towerTextureNode)
        
        //add ProjectilesNote to GameScene
        addChild(ProjectileNodes.projectilesNode)
        
        setupEnemies()
        addChild(EnemyNodes.enemiesNode)
        
        
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
        pathfindingTestEnemy = Enemy(texture: SKTexture(imageNamed: "joystick"), color: .clear)
        let spawnPoint = childNode(withName: "SpawnPoint")
        pathfindingTestEnemy!.position = spawnPoint!.position
        pathfindingTestEnemy!.movePoints = pathfindingTestEnemy!.getMovePoints()
        addChild(pathfindingTestEnemy!)
        
        var enemyChoices = [EnemyTypes]()
        
        enemyChoices.append(.standard)
        enemyChoices.append(.flying)
        enemyChoices.append(.heavy)
        enemyChoices.append(.fast)
        
        waveManager = WaveManager(totalSlots: WaveData.WAVE_STANDARD_SIZE, choises: enemyChoices, enemyRace: .slime)

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
        
        if !GameSceneCommunicator.instance.isBuildPhase {
            
            waveManager!.update()
            
            for node in EnemyNodes.enemiesNode.children{
                
                let enemy = node as! Enemy
                enemy.update()
            }
        }
        
    }
    
    
}

typealias tileCoordinates = (column: Int, row: Int)
