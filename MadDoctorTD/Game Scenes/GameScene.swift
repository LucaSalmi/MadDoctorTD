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
    
    static var instance: GameScene? = nil
    
    var previousCameraScale = CGFloat()
    
    var edgesTilesNode: SKNode = SKNode()
    var hpBarsNode: SKNode = SKNode()
    var towerIndicatorsNode: SKNode = SKNode()
    var foundationIndicatorsNode: SKNode = SKNode()
    
    var pathfindingTestEnemy: Enemy?
    var nodeGraph: GKObstacleGraph? = nil
    var waveManager: WaveManager? = nil
    
    var rangeIndicator: SKShapeNode?
    
    var towerUI: SKSpriteNode? = nil
    var upgradeUI: SKSpriteNode? = nil
    var buildButtonsUI: SKSpriteNode? = nil
    var towerImage: SKSpriteNode?
    var towerNameText: SKLabelNode?
    
    var rateOfFireImage: SKSpriteNode?
    var damageImage: SKSpriteNode?
    var rangeImage: SKSpriteNode?
    
    //Price Labelnodes
    var gunTowerPrice: SKLabelNode?
    var rapidTowerPrice: SKLabelNode?
    var cannonTowerPrice: SKLabelNode?
    var sniperTowerPrice: SKLabelNode?
    
    var towerPriceTags = [SKLabelNode]()
    
    var touchingTower: SKSpriteNode? = nil
    
    var snappedToFoundation: FoundationPlate? = nil
    
    var uiNode = SKNode()
    
    var clickableTileGridsNode = SKNode()
    
    var isMovingCamera = false
    
    var doorOne: SKSpriteNode = SKSpriteNode()
    var doorTwo: SKSpriteNode = SKSpriteNode()
    let doorsAnimationTime: Int = 120
    var doorsAnimationCount: Int = 0
    
    var moveCameraToPortal: Bool = false
    var portalPosition: CGPoint = CGPoint(x: 0, y: 0)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMove(to view: SKView) {
        
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
        
        //creates and adds clickable tiles to GameScene
        let _ = ClickableTileFactory()
        addChild(ClickableTilesNodes.clickableTilesNode)
        
        setupEdges()
        addChild(edgesTilesNode)
        
        setupCamera()
        
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
        addChild(hpBarsNode)
        
        let uiScene = SKScene(fileNamed: "TowerMenuScene")
        towerUI = uiScene!.childNode(withName: "TowerMenu") as? SKSpriteNode
        towerUI!.removeFromParent()
        self.camera!.addChild(towerUI!)
        self.addChild(uiNode)
        
        upgradeUI = uiScene!.childNode(withName: "UpgradeMenu") as? SKSpriteNode
        upgradeUI?.removeFromParent()
        towerImage = upgradeUI?.childNode(withName: "TowerLogo") as? SKSpriteNode
        towerNameText = upgradeUI?.childNode(withName: "TowerText") as? SKLabelNode
        
        damageImage = upgradeUI?.childNode(withName: "AttackButton") as? SKSpriteNode
        rateOfFireImage = upgradeUI?.childNode(withName: "RateOfFireButton") as? SKSpriteNode
        rangeImage = upgradeUI?.childNode(withName: "RangeButton") as? SKSpriteNode
        
        buildButtonsUI = uiScene!.childNode(withName: "BuildButtons") as? SKSpriteNode
        buildButtonsUI?.removeFromParent()
        self.camera!.addChild(buildButtonsUI!)
        
        self.camera!.addChild(upgradeUI!)
        
        sniperTowerPrice = towerUI?.childNode(withName: "SniperTowerPrice") as? SKLabelNode
        rapidTowerPrice = towerUI?.childNode(withName: "RapidTowerPrice") as? SKLabelNode
        cannonTowerPrice = towerUI?.childNode(withName: "CannonTowerPrice") as? SKLabelNode
        gunTowerPrice = towerUI?.childNode(withName: "GunTowerPrice") as? SKLabelNode
        
        gunTowerPrice?.text = "\(TowerData.BASE_COST)$"
        rapidTowerPrice?.text = "\(TowerData.BASE_COST)$"
        cannonTowerPrice?.text = "\(TowerData.BASE_COST)$"
        sniperTowerPrice?.text = "\(TowerData.BASE_COST)$"
        
        towerPriceTags.append(gunTowerPrice!)
        towerPriceTags.append(rapidTowerPrice!)
        towerPriceTags.append(cannonTowerPrice!)
        towerPriceTags.append(sniperTowerPrice!)
        
        addChild(clickableTileGridsNode)
        
        addChild(towerIndicatorsNode)
        addChild(foundationIndicatorsNode)
        
        doorOne = childNode(withName: "doorOne") as! SKSpriteNode
        doorOne.position.x = self.position.x - (doorOne.size.width/2)
        doorTwo = childNode(withName: "doorTwo") as! SKSpriteNode
        doorTwo.position.x = self.position.x + (doorTwo.size.width/2)
        doorsAnimationCount = doorsAnimationTime
        GameSceneCommunicator.instance.closeDoors = false
        GameSceneCommunicator.instance.openDoors = true
        
        moveCameraToPortal = false
        
    }
    
    private func setupCamera(){
        
        let myCamera = self.camera
        let backgroundMap = (childNode(withName: "superBackground") as! SKTileMapNode)
        
        let xInset = min((view?.bounds.width)!/2, backgroundMap.frame.width/2)
        let yInset = min((view?.bounds.height)!/2, backgroundMap.frame.height/2)
        
        let constrainRect = backgroundMap.frame.insetBy(dx: xInset, dy: yInset)
        
        let yLowerLimit = constrainRect.minY/6
        
        let xRange = SKRange(lowerLimit: constrainRect.minX/4, upperLimit: constrainRect.maxX/4)
        let yRange = SKRange(lowerLimit: yLowerLimit, upperLimit: constrainRect.maxY/6)
        
        let edgeConstraint = SKConstraint.positionX(xRange, y: yRange)
        edgeConstraint.referenceNode = backgroundMap
        
        myCamera!.constraints = [edgeConstraint]
        
        let pinchGesture = UIPinchGestureRecognizer()
        pinchGesture.addTarget(self, action: #selector(pinchGestureAction(_:)))
        view?.addGestureRecognizer(pinchGesture)
        
        myCamera!.position = CGPoint(x: 0, y: yLowerLimit)
        
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
        pathfindingTestEnemy?.alpha = 0
        let spawnPoint = childNode(withName: "SpawnPoint")
        pathfindingTestEnemy!.position = spawnPoint!.position
        pathfindingTestEnemy!.movePoints = pathfindingTestEnemy!.getMovePoints()
        addChild(pathfindingTestEnemy!)
        
        waveManager = WaveManager(totalSlots: WaveData.WAVE_STANDARD_SIZE, choises: [.standard], enemyRace: .slime)
        
        portalPosition = spawnPoint!.position
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if GameManager.instance.isPaused {
            return
        }
        
        guard let touch = touches.first else{return}
        let location = touch.location(in: self)
        
        if GameSceneCommunicator.instance.foundationEditMode {
            
            if touch.tapCount >= 2 {
                panForTranslation(touch: touch)
            }
            else {
                let touchedNodes = nodes(at: location)
                GameSceneCommunicator.instance.editFoundationTouchMove(touchedNodes: touchedNodes)
            }
            
            return
        }
        
        if touchingTower != nil{
            
            
            
            touchingTower?.position = location
            rangeIndicator?.position = location
            
            for node in FoundationPlateNodes.foundationPlatesNode.children{
                let foundationPlate = node as! FoundationPlate
                if foundationPlate.contains(location){
                    if !foundationPlate.hasTower{
                        touchingTower?.position = foundationPlate.position
                        snappedToFoundation = foundationPlate
                        rangeIndicator?.position = foundationPlate.position
                        break
                    }
                }
                else {
                    snappedToFoundation = nil
                    
                }
            }
            
            return
        }
        
        
        panForTranslation(touch: touch)
        
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        
        if touchingTower == nil{
            return
        }
        
        rangeIndicator?.removeFromParent()
        rangeIndicator = nil
        
        switch touchingTower!.name{
        case "GunTower":
            if snappedToFoundation != nil{
                print("built tower woho")
                snappedToFoundation!.hasTower = true
                TowerFactory(towerType: TowerTypes.gunTower).createTower(currentFoundation: snappedToFoundation!)
                GameManager.instance.currentMoney -= TowerData.BASE_COST
                snappedToFoundation = nil
                SoundManager.playSFX(sfxName: SoundManager.buildingPlacementSFX, scene: GameScene.instance!, sfxExtension: SoundManager.wavExtension)
                
            }
            touchingTower!.removeFromParent()
            towerUI?.addChild(touchingTower!)
            
            let gunTowerHub = towerUI?.childNode(withName: "GunTowerHub")
            touchingTower!.position = gunTowerHub!.position
            
            
        case "SpeedTower":
            if snappedToFoundation != nil{
                snappedToFoundation!.hasTower = true
                TowerFactory(towerType: TowerTypes.rapidFireTower).createTower(currentFoundation: snappedToFoundation!)
                GameManager.instance.currentMoney -= TowerData.BASE_COST
                snappedToFoundation = nil
                SoundManager.playSFX(sfxName: SoundManager.buildingPlacementSFX, scene: GameScene.instance!, sfxExtension: SoundManager.wavExtension)
            }
            touchingTower!.removeFromParent()
            towerUI?.addChild(touchingTower!)
            
            let gunTowerHub = towerUI?.childNode(withName: "SpeedTowerHub")
            touchingTower!.position = gunTowerHub!.position
            
            
        case "CannonTower":
            if snappedToFoundation != nil{
                snappedToFoundation!.hasTower = true
                TowerFactory(towerType: TowerTypes.cannonTower).createTower(currentFoundation: snappedToFoundation!)
                GameManager.instance.currentMoney -= TowerData.BASE_COST
                snappedToFoundation = nil
                SoundManager.playSFX(sfxName: SoundManager.buildingPlacementSFX, scene: GameScene.instance!, sfxExtension: SoundManager.wavExtension)
            }
            touchingTower!.removeFromParent()
            towerUI?.addChild(touchingTower!)
            
            let gunTowerHub = towerUI?.childNode(withName: "CannonTowerHub")
            touchingTower!.position = gunTowerHub!.position
            
        case "SniperTower":
            if snappedToFoundation != nil{
                snappedToFoundation!.hasTower = true
                TowerFactory(towerType: TowerTypes.sniperTower).createTower(currentFoundation: snappedToFoundation!)
                GameManager.instance.currentMoney -= TowerData.BASE_COST
                snappedToFoundation = nil
                SoundManager.playSFX(sfxName: SoundManager.buildingPlacementSFX, scene: GameScene.instance!, sfxExtension: SoundManager.wavExtension)
            }
            touchingTower!.removeFromParent()
            towerUI?.addChild(touchingTower!)
            
            let gunTowerHub = towerUI?.childNode(withName: "SniperTowerHub")
            touchingTower!.position = gunTowerHub!.position
            
        default:
            print("Error")
        }
        
        touchingTower?.size = CGSize(width: 150, height: 150)
        touchingTower = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if GameManager.instance.isPaused || isMovingCamera{
            return
        }
        
        if rangeIndicator != nil{
            rangeIndicator!.removeFromParent()
        }
        
        let communicator = GameSceneCommunicator.instance
        communicator.cancelAllMenus()
        
        guard let touch = touches.first else {return}
        
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        if GameSceneCommunicator.instance.foundationEditMode {
            communicator.editFoundationTouchStart(touchedNodes: touchedNodes)
            return
        }
        
        for node in touchedNodes {
            
            
            if node.name == "GunTower" || node.name == "SpeedTower" ||
                node.name == "CannonTower" || node.name == "SniperTower"{
                
                //call function that takes in name of node
                if dragAndDropBuild(node: node, location: location){
                    
                    touchingTower!.removeFromParent()
                    uiNode.addChild(touchingTower!)
                    touchingTower?.position = location
                }

                return
            }
        }
        
        for node in touchedNodes {
            
            if node is Tower{
                
                let tower = node as! Tower
                
                towerImage?.texture = tower.onClick()
                damageImage?.texture = SKTexture(imageNamed: "damage_upgrade_\(tower.damageUpgradeCount)")
                rangeImage?.texture = SKTexture(imageNamed: "range_upgrade_\(tower.rangeUpgradeCount)")
                rateOfFireImage?.texture = SKTexture(imageNamed: "speed_upgrade_\(tower.rateOfFireUpgradeCount)")
                
                towerNameText?.text = tower.getName()
                
                towerUI?.alpha = 0
                upgradeUI?.alpha = 1
                
                return
                
            }
        }
        
        for node in touchedNodes{
            
            if node.name == "RateOfFireButton" || node.name == "RangeButton" ||
                node.name == "AttackButton"{
                
                upgradeTowerMenu(nodeName: node.name!)
                return
                
            }
        }
        
        
        for node in touchedNodes {
            
            if node.name == "SellButton" || node.name == "BuildFoundationButton"
                || node.name == "BuildTowerButton"{
                
                extraButtons(nodeName: node.name!)
                return
            }
        }
        
        for node in touchedNodes {
            
            if node is FoundationPlate {
                
                let foundationPlate = node as! FoundationPlate
                foundationPlate.onClick()
                return
            }
        }
        
        if upgradeUI?.alpha == 1{
            towerUI?.alpha = 1
            upgradeUI?.alpha = 0
        }
        
        
    }
    
    private func extraButtons(nodeName: String){
        
        let communicator = GameSceneCommunicator.instance
        
        switch nodeName{
            
        case "SellButton":
            GameSceneCommunicator.instance.sellTower()
            
        case "BuildFoundationButton":
            
            if communicator.foundationEditMode {
                communicator.confirmFoundationEdit()
            }else{
                communicator.foundationEditMode = true
                communicator.toggleFoundationGrid()
            }
            
        case "BuildTowerButton":
            print("Put TowerMenu here")
            
        default:
            print("error with extra buttons")
        }
        
        if upgradeUI?.alpha == 1{
            towerUI?.alpha = 1
            upgradeUI?.alpha = 0
        }
        
    }
    
    private func upgradeTowerMenu(nodeName: String){
        
        switch nodeName{
            
        case "RateOfFireButton":
            GameSceneCommunicator.instance.upgradeTower(upgradeType: .firerate)
            
        case "RangeButton":
            GameSceneCommunicator.instance.upgradeTower(upgradeType: .range)
            
        case "AttackButton":
            GameSceneCommunicator.instance.upgradeTower(upgradeType: .damage)
            
        default:
            print("error with upgrade menu")
            
        }
    }
    
    
    private func dragAndDropBuild(node: SKNode, location: CGPoint) -> Bool{
        
        guard let nodeName = node.name else {return false}
        
        switch nodeName{
            
        case "GunTower":
            
            if TowerData.BASE_COST > GameManager.instance.currentMoney{
                return false
            }
            
            displayRangeIndicator(attackRange: TowerData.ATTACK_RANGE, position: location)
            touchingTower = node as? SKSpriteNode
            touchingTower?.size = TowerData.TEXTURE_SIZE
            SoundManager.playSFX(sfxName: SoundManager.buttonOneSFX, scene: GameScene.instance!, sfxExtension: SoundManager.mp3Extension)
            
        case "SpeedTower":
            if TowerData.BASE_COST > GameManager.instance.currentMoney || !GameManager.instance.rapidFireTowerUnlocked{
                return false
            }
            
            displayRangeIndicator(attackRange: TowerData.ATTACK_RANGE * 0.5, position: location)
            touchingTower = node as? SKSpriteNode
            touchingTower?.size = TowerData.TEXTURE_SIZE
            SoundManager.playSFX(sfxName: SoundManager.buttonTwoSFX, scene: GameScene.instance!, sfxExtension: SoundManager.mp3Extension)
            
            
        case "CannonTower":
            
            if TowerData.BASE_COST > GameManager.instance.currentMoney || !GameManager.instance.cannonTowerUnlocked{
                return false
            }
            
            displayRangeIndicator(attackRange: TowerData.ATTACK_RANGE * 0.8, position: location)
            touchingTower = node as? SKSpriteNode
            touchingTower?.size = TowerData.TEXTURE_SIZE
            SoundManager.playSFX(sfxName: SoundManager.buttonThreeSFX, scene: GameScene.instance!, sfxExtension: SoundManager.mp3Extension)
            
        case "SniperTower":
            
            if TowerData.BASE_COST > GameManager.instance.currentMoney || !GameManager.instance.sniperTowerUnlocked{
                return false
            }
            
            displayRangeIndicator(attackRange: TowerData.ATTACK_RANGE * 1.8, position: location)
            touchingTower = node as? SKSpriteNode
            touchingTower?.size = TowerData.TEXTURE_SIZE
            SoundManager.playSFX(sfxName: SoundManager.buttonFourSFX, scene: GameScene.instance!, sfxExtension: SoundManager.mp3Extension)
            
            
        default:
            print("error")
        }
        
        if upgradeUI?.alpha == 1{
            towerUI?.alpha = 1
            upgradeUI?.alpha = 0
        }
        return true
        
        
    }
    
    
    func tile(in tileMap: SKTileMapNode, at coordinates: tileCoordinates) -> SKTileDefinition?{
        return tileMap.tileDefinition(atColumn: coordinates.column, row: coordinates.row)
    }
    
    func displayRangeIndicator(attackRange: CGFloat, position: CGPoint){
        
        if rangeIndicator != nil{
            rangeIndicator!.removeFromParent()
            
        }
        
        rangeIndicator = SKShapeNode(circleOfRadius: attackRange)
        rangeIndicator!.name = "RangeIndicator"
        rangeIndicator!.fillColor = SKColor(.white.opacity(0.2))
        
        rangeIndicator!.zPosition = 2
        rangeIndicator!.position = position
        
        addChild(rangeIndicator!)
        
    }
    
    private func animateDoors() {
        
        if GameSceneCommunicator.instance.openDoors {
            doorOne.position.x -= 1
            doorTwo.position.x += 1
        }
        
        if GameSceneCommunicator.instance.closeDoors {
            doorOne.position.x += 1
            doorTwo.position.x -= 1
        }
        
        doorsAnimationCount -= 1
        if doorsAnimationCount <= 0 {
            
            //fail safe to reset doors position to orginal position
            if GameSceneCommunicator.instance.closeDoors {
                doorOne.position.x = self.position.x - (doorOne.size.width/2)
                doorTwo.position.x = self.position.x + (doorTwo.size.width/2)
            }
            
            GameSceneCommunicator.instance.closeDoors = false
            GameSceneCommunicator.instance.openDoors = false
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        //Runs every frame
        
        if GameManager.instance.isPaused || GameManager.instance.isGameOver{
            return
        }
        
        if GameSceneCommunicator.instance.openDoors || GameSceneCommunicator.instance.closeDoors {
            animateDoors()
            return
        }
        
        if GameManager.instance.currentMoney < TowerData.BASE_COST{
            for node in towerUI!.children{
                if node.alpha != 0.5{
                    node.alpha = 0.5
                    for tag in towerPriceTags {
                        tag.fontColor = UIColor(Color.red)
                    }
                }
            }
        }
        
        
        if moveCameraToPortal {
            let cameraDirection = PhysicsUtils.getCameraDirection(camera: self.camera!, targetPoint: portalPosition)
            PhysicsUtils.moveCameraToTargetPoint(camera: self.camera!, direction: cameraDirection)
            
            let portal = SKSpriteNode()
            portal.position = portalPosition
            portal.size = CGSize(width: 86, height: 400)
            if portal.contains(camera!.position) {
                moveCameraToPortal = false
            }
        }
        
        for node in TowerNode.towersNode.children {
            let tower = node as! Tower
            tower.update()
            
        }
        
        if GameManager.instance.currentMoney < TowerData.BASE_COST{
            for node in towerUI!.children{
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
        
        if !GameSceneCommunicator.instance.isBuildPhase {
            
            waveManager!.update()
            
            for node in EnemyNodes.enemiesNode.children{
                
                let enemy = node as! Enemy
                enemy.update()
            }
        }
    }
    
    
    func resetGameScene(){
        
        //Tower
        TowerNode.towerArray.removeAll()
        TowerNode.towersNode.removeAllChildren()
        TowerNode.towersNode.removeFromParent()
        TowerNode.towerTextureNode.removeAllChildren()
        TowerNode.towerTextureNode.removeFromParent()
        towerIndicatorsNode.removeAllChildren()
        towerIndicatorsNode.removeFromParent()
        
        //Enemies
        EnemyNodes.enemiesNode.removeAllChildren()
        EnemyNodes.enemiesNode.removeFromParent()
        EnemyNodes.enemyArray.removeAll()
        
        //HP bars
        hpBarsNode.removeAllChildren()
        hpBarsNode.removeFromParent()
        
        //Foundation
        FoundationPlateNodes.foundationPlatesNode.removeAllChildren()
        FoundationPlateNodes.foundationPlatesNode.removeFromParent()
        foundationIndicatorsNode.removeAllChildren()
        foundationIndicatorsNode.removeFromParent()
        
        //ClickableTiles
        ClickableTilesNodes.clickableTilesNode.removeAllChildren()
        ClickableTilesNodes.clickableTilesNode.removeFromParent()
        
        //Projectiles
        ProjectileNodes.projectilesNode.removeAllChildren()
        ProjectileNodes.projectilesNode.removeFromParent()
        ProjectileNodes.gunProjectilesPool.removeAll()
        
        //Edge
        edgesTilesNode.removeAllChildren()
        edgesTilesNode.removeFromParent()
        
        //Economy
        GameManager.instance.currentMoney = PlayerData.START_MONEY
        GameManager.instance.researchPoints = PlayerData.START_RESEARCH_POINTS
        GameManager.instance.baseHp = PlayerData.BASE_HP
        GameManager.instance.cannonTowerUnlocked = false
        GameManager.instance.rapidFireTowerUnlocked = false
        GameManager.instance.sniperTowerUnlocked = false
        
        //Wave
        GameManager.instance.currentWave = 0
        GameManager.instance.nextWaveCounter = 0
        
        //UI
        self.camera!.removeAllChildren()
        self.uiNode.removeFromParent()
        
        //Foundation edit mode
        clickableTileGridsNode.removeFromParent()
    }
    
    
    func panForTranslation(touch: UITouch) {
        
        if moveCameraToPortal {
            return
        }
        
        let positionInScene = touch.location(in: self)
        let previousPosition = touch.previousLocation(in: self)
        let translation = CGPoint(x: (positionInScene.x) - (previousPosition.x), y: (positionInScene.y) - (previousPosition.y))
        
        let position = camera!.position
        let aNewPosition = CGPoint(x: position.x - translation.x, y: position.y - translation.y)
        camera!.position = aNewPosition
        isMovingCamera = false
    }
    
    
    @objc func pinchGestureAction(_ sender: UIPinchGestureRecognizer) {
        guard let camera = self.camera else {
            return
        }
        
        if sender.state == .began {
            
            previousCameraScale = camera.xScale
        }
        
        let newCameraScale = previousCameraScale * 1 / sender.scale
        
        if newCameraScale < 0.5 || newCameraScale > 1.3{
            
            return
            
        }
        
        camera.setScale(newCameraScale)
        
    }
    
}

typealias tileCoordinates = (column: Int, row: Int)
