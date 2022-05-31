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
import UIKit

class GameScene: SKScene {

    @ObservedObject var gameManager = GameManager.instance
    
    static var instance: GameScene? = nil
    
    //Enemy stuff
    var pathfindingTestEnemy: Enemy?
    var nodeGraph: GKObstacleGraph? = nil
    var waveManager: WaveManager? = nil
    var enemyRaceSwitch: [EnemyRaces] = [.slime, .squid]
    
    //UI Stuff
    
    var uiManager: UIManager? = nil
    
    var fadeInScene = false
    var fadeOutScene = false
    var transitionAmount: Double = 0.02
    
    //user input stuff
    var touchStarted = true
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMove(to view: SKView) {
        
        AppManager.appManager.transitionOpacity = 1
        fadeInScene = true
        
        if GameManager.instance.isGameOver{
            gameSetup()
            return
        }
        
        if GameScene.instance != nil {
            return
        }
        
        GameScene.instance = self
        physicsWorld.contactDelegate = self
        gameSetup()
        
    }
    
    func gameSetup(){
        
        GameManager.instance.isGameOver = false
        GameSceneCommunicator.instance.isBuildPhase = true
        
        uiManager = UIManager()
        uiManager!.setupUI()
        
        //creates and adds clickable tiles to GameScene
        let _ = ClickableTileFactory()
        addChild(ClickableTilesNodes.clickableTilesNode)
        
        
        setupEdges()
        
        uiManager!.setupCamera()
        
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
                uiManager!.edgesTilesNode.addChild(edge)
                
            }
        }
        
        //edgesTileMap.removeFromParent()
    }
    
    private func setupEnemies(){
        
        //build phase pathfinding test
        pathfindingTestEnemy = Enemy(texture: SKTexture(imageNamed: "joystick"), color: .clear)
        pathfindingTestEnemy?.alpha = 0
        let spawnPoint = childNode(withName: "SpawnPoint")
        pathfindingTestEnemy!.position = spawnPoint!.position
        pathfindingTestEnemy!.movePoints = pathfindingTestEnemy!.getMovePoints()
        addChild(pathfindingTestEnemy!)
        
        waveManager = WaveManager(totalSlots: WaveData.WAVE_STANDARD_SIZE, choises: [.standard])
        
    }
    
    func tile(in tileMap: SKTileMapNode, at coordinates: tileCoordinates) -> SKTileDefinition?{
        return tileMap.tileDefinition(atColumn: coordinates.column, row: coordinates.row)
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        //Runs every frame
        
        if fadeInScene {
            AppManager.appManager.transitionOpacity -= transitionAmount
            if AppManager.appManager.transitionOpacity <= 0 {
                fadeInScene = false
            }
        }
        
        if fadeOutScene {
            
            AppManager.appManager.transitionOpacity += transitionAmount
            
            if AppManager.appManager.transitionOpacity >= 1 {
                fadeOutScene = false
                AppManager.appManager.transitionOpacity = 0
                AppManager.appManager.state = .startMenu
                //SoundManager.playBGM(bgmString: SoundManager.ambienceOne, bgmExtension: SoundManager.mp3Extension)
            }
            
        }
        
//        if touchStarted{
//            handleLongPress()
//        }else if uiManager!.statUpgradePopUp?.alpha == 1{
//            uiManager!.statUpgradePopUp?.alpha = 0
//        }
        
        if GameManager.instance.isPaused || GameManager.instance.isGameOver{
            return
        }
        
        if uiManager!.zoomOutCamera {
            uiManager!.performZoomOut()
        }
        
        if uiManager!.fadeInPortal{
            uiManager!.fadePortal(fadeIn: true)
        }
        if uiManager!.fadeOutPortal{
            uiManager!.fadePortal(fadeIn: false)
        }
    
        if GameSceneCommunicator.instance.openDoors || GameSceneCommunicator.instance.closeDoors {
            uiManager!.animateDoors()
            
            if GameSceneCommunicator.instance.closeDoors {
                return
            }
        }
        
        if GameManager.instance.currentMoney < TowerData.BASE_COST{
            for node in uiManager!.towerUI!.children{
                if node.alpha != 0.5{
                    node.alpha = 0.5
                    
                }
            }
            if uiManager!.towerPriceTags.first!.fontColor != UIColor(Color.red){
                for tag in uiManager!.towerPriceTags {
                    tag.fontColor = UIColor(Color.red)
                }
            }
        }
        else{
            for node in uiManager!.towerUI!.children{
                if node.alpha != 1{
                    node.alpha = 1
                }
            }
            if uiManager!.towerPriceTags.first!.fontColor != UIColor(Color.green){
                for tag in uiManager!.towerPriceTags{
                    tag.fontColor = UIColor(Color.green)
                }
            }
        }
        
        if uiManager!.priceTag!.alpha > 0 && uiManager!.touchingTower == nil{
            uiManager!.priceTag!.alpha -= 0.03
            uiManager!.priceTag!.position.y += 1.5
        }
        
        if uiManager!.moveCameraToDoors {
            
            uiManager!.performMoveCameraToDoors()
        }
        if uiManager!.moveCameraToPortal {
            
            uiManager!.performMoveCameraToPortal()
            
        }
        if uiManager!.hideBuildMenu{
            uiManager!.hideBuildButtonsUI()
        }
        else{
            uiManager!.showBuildButtonsUI()
        }
        
        for node in TowerNode.towersNode.children {
            let tower = node as! Tower
            tower.update()
            
        }
        
        if GameManager.instance.currentMoney < TowerData.BASE_COST{
            for node in uiManager!.towerUI!.children{
                if node.alpha != 0.5{
                    node.alpha = 0.5
                }
            }
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
        
        for node in uiManager!.moneyNode.children {
            
            if node is MoneyObject{
                
                let moneyObject = node as! MoneyObject
                moneyObject.update()
                
            }else if node is DropObject{
                
                let drop = node as! DropObject
                drop.update()
            }
        }
        
        if uiManager!.foundationIndicator!.alpha != 0 {
            
            uiManager!.updateRangeIndicatorAlpha()
        }
        
        if !GameSceneCommunicator.instance.isBuildPhase {
            
            waveManager!.update()
            
            for node in EnemyNodes.enemiesNode.children{
                
                let enemy = node as! Enemy
                enemy.update()
            }
        }
        if uiManager!.showDamageIndicator{
            GameManager.instance.displayDamageIndicator()
        }
    }
    
    
    
    func resetGameScene(){
        
        //UI
        uiManager!.resetUI()
        
        //Tower
        TowerNode.towerArray.removeAll()
        TowerNode.towersNode.removeAllChildren()
        TowerNode.towersNode.removeFromParent()
        TowerNode.towerTextureNode.removeAllChildren()
        TowerNode.towerTextureNode.removeFromParent()
        
        //Enemies
        EnemyNodes.enemiesNode.removeAllChildren()
        EnemyNodes.enemiesNode.removeFromParent()
        EnemyNodes.enemyArray.removeAll()
        
        //Foundation
        FoundationPlateNodes.foundationPlatesNode.removeAllChildren()
        FoundationPlateNodes.foundationPlatesNode.removeFromParent()
        
        //ClickableTiles
        ClickableTilesNodes.clickableTilesNode.removeAllChildren()
        ClickableTilesNodes.clickableTilesNode.removeFromParent()
        
        //Projectiles
        ProjectileNodes.projectilesNode.removeAllChildren()
        ProjectileNodes.projectilesNode.removeFromParent()
        ProjectileNodes.gunProjectilesPool.removeAll()
        
        //Economy
        GameManager.instance.currentMoney = PlayerData.START_MONEY
        GameManager.instance.researchPoints = PlayerData.START_RESEARCH_POINTS
        GameManager.instance.baseHp = PlayerData.BASE_HP
        gameManager.resetAllSkills()
        
        //Wave
        GameManager.instance.currentWave = 0
        GameManager.instance.nextWaveCounter = 0
        
        //Boss
        for child in self.children{
            
            if child.name == "BossTexture"{
                child.removeFromParent()
            }
        }
    }
    
    
}

typealias tileCoordinates = (column: Int, row: Int)
