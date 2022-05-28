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
    
    var previousCameraScale = CGFloat()
    
    var projectileShadowNode: SKNode = SKNode()
    var edgesTilesNode: SKNode = SKNode()
    var hpBarsNode: SKNode = SKNode()
    var towerIndicatorsNode: SKNode = SKNode()
    var foundationIndicatorsNode: SKNode = SKNode()
    
    var pathfindingTestEnemy: Enemy?
    var nodeGraph: GKObstacleGraph? = nil
    var waveManager: WaveManager? = nil
    
    //UI Stuff
    var mainHubBackground: SKSpriteNode?
    var foundationIndicator: SKSpriteNode?
    var foundationIndicatorIncrease: Bool = false
    var rangeIndicator: SKShapeNode?
    var towerUI: SKSpriteNode? = nil
    var upgradeUI: SKSpriteNode? = nil
    var upgradeMenuToggle: SKSpriteNode?
    var foundationUI: SKSpriteNode? = nil
    var foundationMenuToggle: SKSpriteNode? = nil
    var foundationRepairButton: SKSpriteNode?
    var foundationUpgradeButton: SKSpriteNode?
    var sellFoundationButton: SKSpriteNode?
    var buildButtonsUI: SKSpriteNode? = nil
    var readyButton: SKSpriteNode?
    var researchButton: SKSpriteNode?
    var buildFoundationButton: SKSpriteNode?
    var towerImage: SKSpriteNode?
    var towerNameText: SKLabelNode?
    var damageIndicator: SKSpriteNode?
    
    //Summary Screen
    var waveSummary: SKSpriteNode?
    var summaryTitle: SKLabelNode?
    var bossMaterialGained: SKLabelNode?
    var researchPointsGained: SKLabelNode?
    var summaryBackButton: SKSpriteNode?

    var summary: SKLabelNode?
    //var enemiesDefeated: SKLabelNode?
    var enemiesDefeatedNumber: SKLabelNode?
    //var researchPointsGainedTwo: SKLabelNode?
    var researchPointsGainedNumber: SKLabelNode?
    //var creditsGained: SKLabelNode?
    var creditsGainedNumber: SKLabelNode?
    //var baseHPLost: SKLabelNode?
    var baseHPLostNumber: SKLabelNode?
    //var ratingGained: SKLabelNode?
    //var ratingGainedNumber: SKLabelNode?
    
    //portal
    var portal: SKTileMapNode?
    //var ratingGained: SKLabelNode?
    //var ratingGainedNumber: SKLabelNode?
    //var survivalBonus: SKLabelNode?
    var survivalBonusNumber: SKLabelNode?

    //towerInfo
    var towerInfoMenu: SKSpriteNode?
    var attackStatLabel: SKLabelNode?
    var fireRateStatLabel: SKLabelNode?
    var rangeStatLabel: SKLabelNode?
    var towerLogoInfo: SKSpriteNode?
    
    //preview
    var statUpgradePopUp: SKSpriteNode?
    var statUpgradePreviewText: SKLabelNode?
    var upgradeTypePreview: UpgradeTypes?
    
    var showDamageIndicator: Bool = false
    var fadeInPortal = false
    var fadeOutPortal = false
    
    var rateOfFireImage: SKSpriteNode?
    var damageImage: SKSpriteNode?
    var rangeImage: SKSpriteNode?
    
    //Price Labelnodes
    var gunTowerPrice: SKLabelNode?
    var rapidTowerPrice: SKLabelNode?
    var cannonTowerPrice: SKLabelNode?
    var sniperTowerPrice: SKLabelNode?
    var priceTag: SKLabelNode?
    
    var towerPriceTags = [SKLabelNode]()
    
    var touchingTower: SKSpriteNode? = nil
    
    var snappedToFoundation: FoundationPlate? = nil
    
    var uiNode = SKNode()
    
    var clickableTileGridsNode = SKNode()
    
    var doorOne: SKSpriteNode = SKSpriteNode()
    var doorTwo: SKSpriteNode = SKSpriteNode()
    let doorsAnimationTime: Int = 120
    var doorsAnimationCount: Int = 0
    
    var moveCameraToPortal: Bool = false
    var portalPosition: CGPoint = CGPoint(x: 0, y: 0)
    
    var moneyNode: SKNode = SKNode()
    
    var dialoguesNode: SKNode = SKNode()
    var showNewMaterialMessage = false
    
    var enemyRaceSwitch: [EnemyRaces] = [.slime, .squid]
    
    var touchStarted = true
    
    var fadeInScene = false
    var fadeOutScene = false
    var transitionAmount: Double = 0.02
    
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
        
        //creates and adds clickable tiles to GameScene
        let _ = ClickableTileFactory()
        addChild(ClickableTilesNodes.clickableTilesNode)
        addChild(projectileShadowNode)
        
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
        
        portal = self.childNode(withName: "Tile Map Node") as? SKTileMapNode
        portal?.xScale = 0
        portal?.yScale = 0
        
        
        let uiScene = SKScene(fileNamed: "GameUIScene")
        towerUI = uiScene!.childNode(withName: "TowerMenu") as? SKSpriteNode
        towerUI!.removeFromParent()
        foundationUI = uiScene?.childNode(withName: "FoundationMenu") as? SKSpriteNode
        foundationUI?.removeFromParent()
        damageIndicator = uiScene?.childNode(withName: "DamageIndicator") as? SKSpriteNode
        damageIndicator?.removeFromParent()
        
        waveSummary = uiScene?.childNode(withName: "WaveSummary") as? SKSpriteNode
        summaryTitle = waveSummary?.childNode(withName: "SummaryTitle") as? SKLabelNode

        // new adds
        summary = waveSummary?.childNode(withName: "Summary") as? SKLabelNode
        //enemiesDefeated = waveSummary?.childNode(withName: "EnemiesDefeated") as? SKLabelNode
        enemiesDefeatedNumber = waveSummary?.childNode(withName: "EnemiesDefeatedNumber") as? SKLabelNode
        //researchPointsGainedTwo = waveSummary?.childNode(withName: "ResearchPointsGained") as? SKLabelNode
        researchPointsGainedNumber = waveSummary?.childNode(withName: "ResearchPointsGainedNumber") as? SKLabelNode
        //creditsGained = waveSummary?.childNode(withName: "CreditsGained") as? SKLabelNode
        creditsGainedNumber = waveSummary?.childNode(withName: "CreditsGainedNumber") as? SKLabelNode
        //baseHPLost = waveSummary?.childNode(withName: "BaseHpLost") as? SKLabelNode
        baseHPLostNumber = waveSummary?.childNode(withName: "BaseHpLostNumber") as? SKLabelNode
//        ratingGained = waveSummary?.childNode(withName: "Rating") as? SKLabelNode
//        ratingGainedNumber = waveSummary?.childNode(withName: "RatingNumber") as? SKLabelNode
        //survivalBonus = waveSummary?.childNode(withName: "SurvivalBonus") as? SKLabelNode
        survivalBonusNumber = waveSummary?.childNode(withName: "SurvivalBonus") as? SKLabelNode
        //creditsGainedNumber?.text = ("$\(gameManager.moneyEarned)")
        //researchPointsGained?.text = ("\(gameManager.researchPoints)")

        //baseHPLostNumber?.text = ("\(gameManager.baseHPLost)") //add variable that tracks HP lost everytime an enemy enters zone
        //ratingGainedNumber?.text = ("S+") //add logic for rating (enemiesDefeated = totalNumerOfEnemies && baseHPLost == 0 or something along those lines..)

        bossMaterialGained = waveSummary?.childNode(withName: "BossMaterial") as? SKLabelNode
        researchPointsGained = waveSummary?.childNode(withName: "ResearchPoints") as? SKLabelNode
        summaryBackButton = waveSummary?.childNode(withName: "BackButton") as? SKSpriteNode
        waveSummary?.removeFromParent()

        mainHubBackground = uiScene!.childNode(withName: "MainHubBackground") as? SKSpriteNode
        //towerInfoMenu
        towerInfoMenu = uiScene?.childNode(withName: "TowerInfoNode") as? SKSpriteNode
        towerInfoMenu?.removeFromParent()
        statUpgradePopUp = uiScene?.childNode(withName: "UpgradeInfoPopUp") as? SKSpriteNode
        statUpgradePopUp?.removeFromParent()

        let mainHubBackground = uiScene!.childNode(withName: "MainHubBackground")
        mainHubBackground?.removeFromParent()
        self.camera!.addChild(waveSummary!)
        self.camera!.addChild(mainHubBackground!)
        self.camera!.addChild(foundationUI!)
        self.camera!.addChild(towerUI!)
        self.camera!.addChild(damageIndicator!)
        self.addChild(uiNode)
        
        self.camera?.addChild(towerInfoMenu!)
        self.camera?.addChild(statUpgradePopUp!)
                
        upgradeUI = uiScene!.childNode(withName: "UpgradeMenu") as? SKSpriteNode
        upgradeUI?.removeFromParent()
        towerImage = upgradeUI?.childNode(withName: "TowerLogo") as? SKSpriteNode
        towerNameText = upgradeUI?.childNode(withName: "TowerText") as? SKLabelNode
        foundationMenuToggle = upgradeUI?.childNode(withName: "FoundationMenuToggle") as? SKSpriteNode
        upgradeMenuToggle = foundationUI?.childNode(withName: "UpgradeMenuToggle") as? SKSpriteNode
        sellFoundationButton = foundationUI?.childNode(withName: "SellFoundationButton") as? SKSpriteNode
        foundationUpgradeButton = foundationUI?.childNode(withName: "UpgradeFoundation") as? SKSpriteNode
        foundationRepairButton = foundationUI?.childNode(withName: "RepairFoundation") as? SKSpriteNode
        
        //towerInfoMenu
        attackStatLabel = towerInfoMenu?.childNode(withName: "TowerInfoAttack") as? SKLabelNode
        fireRateStatLabel = towerInfoMenu?.childNode(withName: "TowerInfoFirerate") as? SKLabelNode
        rangeStatLabel = towerInfoMenu?.childNode(withName: "TowerInfoRange") as? SKLabelNode
        
        statUpgradePreviewText = statUpgradePopUp?.childNode(withName: "upgradePopUpText") as? SKLabelNode
        towerLogoInfo = towerInfoMenu?.childNode(withName: "TowerLogoInfoUI") as? SKSpriteNode
        
        damageImage = upgradeUI?.childNode(withName: "AttackButton") as? SKSpriteNode
        rateOfFireImage = upgradeUI?.childNode(withName: "RateOfFireButton") as? SKSpriteNode
        rangeImage = upgradeUI?.childNode(withName: "RangeButton") as? SKSpriteNode
        
        buildButtonsUI = uiScene!.childNode(withName: "BuildButtons") as? SKSpriteNode
        buildButtonsUI?.removeFromParent()
        self.camera!.addChild(buildButtonsUI!)
        
        readyButton = buildButtonsUI?.childNode(withName: "ReadyButton") as? SKSpriteNode
        
        researchButton = buildButtonsUI?.childNode(withName: "ResearchButton") as? SKSpriteNode
        
        buildFoundationButton = buildButtonsUI?.childNode(withName: "BuildFoundationButton") as? SKSpriteNode
        
        self.camera!.addChild(upgradeUI!)
        
        sniperTowerPrice = towerUI?.childNode(withName: "SniperTowerPrice") as? SKLabelNode
        rapidTowerPrice = towerUI?.childNode(withName: "RapidTowerPrice") as? SKLabelNode
        cannonTowerPrice = towerUI?.childNode(withName: "CannonTowerPrice") as? SKLabelNode
        gunTowerPrice = towerUI?.childNode(withName: "GunTowerPrice") as? SKLabelNode
        priceTag = uiScene?.childNode(withName: "PriceTag") as? SKLabelNode
        priceTag?.removeFromParent()
        uiNode.addChild(priceTag!)
        
        gunTowerPrice?.text = "$\(TowerData.BASE_COST)"
        rapidTowerPrice?.text = "$\(TowerData.BASE_COST)"
        cannonTowerPrice?.text = "$\(TowerData.BASE_COST)"
        sniperTowerPrice?.text = "$\(TowerData.BASE_COST)"
        priceTag?.text = "$\(TowerData.BASE_COST)"

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
        
        addChild(moneyNode)
        addChild(dialoguesNode)
        
        foundationIndicator = SKSpriteNode(texture: nil, color: .white, size: FoundationData.SIZE)
        foundationIndicator!.alpha = 0
        addChild(foundationIndicator!)
    }
    
    private func setupCamera(){
        
        let myCamera = self.camera
        let backgroundMap = (childNode(withName: "edge") as! SKTileMapNode)
        let scaledSize = CGSize(width: size.width * myCamera!.xScale, height: size.height * myCamera!.yScale)
        
        let xInset = min((scaledSize.width/2) - 100.0, backgroundMap.frame.width/2)
        let yInset = min((scaledSize.height/2) - 100.0, backgroundMap.frame.height/2)
        
        let constrainRect = backgroundMap.frame.insetBy(dx: xInset, dy: yInset)
        
        let yLowerLimit = constrainRect.minY
        
        let xRange = SKRange(lowerLimit: constrainRect.minX, upperLimit: constrainRect.maxX)
        let yRange = SKRange(lowerLimit: yLowerLimit, upperLimit: constrainRect.maxY)
        
        let edgeConstraint = SKConstraint.positionX(xRange, y: yRange)
        edgeConstraint.referenceNode = backgroundMap
        
        myCamera!.constraints = [edgeConstraint]
        
        if view?.gestureRecognizers == nil{
            
            let pinchGesture = UIPinchGestureRecognizer()
            pinchGesture.addTarget(self, action: #selector(pinchGestureAction(_:)))
            view?.addGestureRecognizer(pinchGesture)

        }
        
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
        
        waveManager = WaveManager(totalSlots: WaveData.WAVE_STANDARD_SIZE, choises: [.standard])
        
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
            priceTag?.position.y = touchingTower!.position.y - 75
            priceTag?.position.x = touchingTower!.position.x
            return
        }
        
        
        panForTranslation(touch: touch)

    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        if touchingTower == nil{
            
            guard let touch = touches.first else {return}
            
            let location = touch.location(in: self)
            let touchedNodes = nodes(at: location)
            
            for node in touchedNodes{
                
                if node.name == "RateOfFireButton" || node.name == "RangeButton" ||
                    node.name == "AttackButton" || node.name == "FoundationMenuToggle"{
                    
                    touchStarted = false
                    upgradeTowerMenu(nodeName: node.name!)
                    statUpgradePopUp?.alpha = 0
                    return
                    
                }
            }
            touchStarted = false
            return
        }
        
        touchStarted = false
                
        if snappedToFoundation != nil{
            priceTag?.position.x = touchingTower!.position.x
            priceTag?.position.y = touchingTower!.position.y + 50
            priceTag?.alpha = 1
            priceTag?.fontColor = UIColor(Color.red)
        }
        else{
            priceTag?.alpha = 0
        }
        
        for node in towerPriceTags{
            node.alpha = 1
        }
        
        rangeIndicator?.removeFromParent()
        rangeIndicator = nil
        
        switch touchingTower!.name{
        case "GunTower":
            if snappedToFoundation != nil{
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
        
        touchingTower?.size = CGSize(width: 100, height: 100)
        
        touchingTower = nil
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if GameManager.instance.isPaused{
            return
        }
        
        if rangeIndicator != nil{
            rangeIndicator!.removeFromParent()
        }
        
        foundationIndicator!.alpha = 0
        
        let communicator = GameSceneCommunicator.instance
        communicator.cancelAllMenus()
        
        guard let touch = touches.first else {return}
        
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        for node in touchedNodes {
            
            if node.name == "SellTowerButton" || node.name == "SellFoundationButton" || node.name == "BuildFoundationButton"
                || node.name == "BuildTowerButton" || node.name == "ReadyButton" || node.name == "ResearchButton" || node.name == "BackButton"{
                
                extraButtons(nodeName: node.name!)
                return
            }
        }
        
        if GameSceneCommunicator.instance.foundationEditMode {
            communicator.editFoundationTouchStart(touchedNodes: touchedNodes)
            return
        }
        
        for node in touchedNodes{
            if node.name == "UpgradeFoundation" || node.name == "RepairFoundation"{
                switch node.name{
                    
                case "UpgradeFoundation":
                    communicator.upgradeFoundation()
                    
                case "RepairFoundation":
                    
                    communicator.repairFoundation()
                    
                    
                default: print("error")
                }
                
                return
            }
        }
        
        for node in touchedNodes {
            
            
            if node.name == "GunTower" || node.name == "SpeedTower" ||
                node.name == "CannonTower" || node.name == "SniperTower"{
                //SoundManager.playSFX(sfxName: SoundManager.buttonSFX_two, scene: GameScene.instance!, sfxExtension: SoundManager.mp3Extension)
                
                //call function that takes in name of node
                if dragAndDropBuild(node: node, location: location){
                    priceTag?.position.x = location.x
                    priceTag?.position.y = location.y - 75
                    priceTag?.alpha = 1
                    priceTag?.fontColor = UIColor(Color.green)
                    touchingTower!.removeFromParent()
                    uiNode.addChild(touchingTower!)
                    touchingTower?.position = location
                    
                }

                return
            }
        }
        
        for node in touchedNodes{
            
            if node.name == "RateOfFireButton" || node.name == "RangeButton" ||
                node.name == "AttackButton"{
                
                touchStarted = true
                upgradeTowerMenu(nodeName: node.name!)
                return
                
            }
        }
        
        for node in touchedNodes{
            
            if node.name == "FoundationMenuToggle"{
                showFoundationUI()
                return
            }
        }
        
        for node in touchedNodes{
            if node.name == "UpgradeMenuToggle"{
                showUpgradeUI()
                displayRangeIndicator(attackRange: communicator.currentTower!.attackRange, position: communicator.currentTower!.position)
                
                return
            }
        }
        
        for node in touchedNodes{
            if node.name == "TowerLogo"{
                
                showTowerInfo()
                displayRangeIndicator(attackRange: communicator.currentTower!.attackRange, position: communicator.currentTower!.position)
                
                return
            }
            
            
        }
        
        for node in touchedNodes {
            
            if node is Tower{
                let tower = node as! Tower
                tower.onClick()
             
                return
                
            }
        }
        
        if communicator.isBuildPhase{
            for node in touchedNodes {
                
                if node is FoundationPlate {
                    
                    let foundationPlate = node as! FoundationPlate
                    foundationPlate.onClick()
                    
                    return
                }
            }
        }
        
        
        if upgradeUI?.alpha == 1{
            
        }
        showTowerUI()
        
    }
    
    func showTowerInfo(){
        
        guard let currentTower = GameSceneCommunicator.instance.currentTower else {return}
        attackStatLabel?.text = "Attack Power: \(currentTower.attackDamage)"
        fireRateStatLabel?.text = "Fire Rate: \(currentTower.fireRate)"
        rangeStatLabel?.text = "Range: \(Int(currentTower.attackRange))"
        towerLogoInfo?.texture = currentTower.towerTexture.texture
        
        
        towerInfoMenu?.alpha = 1
        towerUI?.alpha = 0
        upgradeUI?.alpha = 0
        foundationUI?.alpha = 0
        
        if GameSceneCommunicator.instance.isBuildPhase{
            foundationMenuToggle?.alpha = 1
        }
        else{foundationMenuToggle?.alpha = 0}
        
    }
    
    func showTowerUI(){
        
        towerUI?.alpha = 1
        upgradeUI?.alpha = 0
        foundationUI?.alpha = 0
        towerInfoMenu?.alpha = 0
        
        if GameSceneCommunicator.instance.isBuildPhase{
            foundationMenuToggle?.alpha = 1
        }
        else{foundationMenuToggle?.alpha = 0}
    
    }
    func showUpgradeUI(){
        towerUI?.alpha = 0
        upgradeUI?.alpha = 1
        foundationUI?.alpha = 0
        towerInfoMenu?.alpha = 0
        
        
        if GameSceneCommunicator.instance.isBuildPhase{
            upgradeMenuToggle?.alpha = 1
        }
    }
    
    func showFoundationUI(){
        towerUI?.alpha = 0
        upgradeUI?.alpha = 0
        foundationUI?.alpha = 1
        towerInfoMenu?.alpha = 0
        let foundation = GameSceneCommunicator.instance.currentFoundation!
        foundation.updateUpgradeButtonTexture()
        displayFoundationIndicator(position: foundation.position)
        
        if foundation.hp < foundation.maxHp{
           
            foundationRepairButton?.alpha = 1
            
            foundationUpgradeButton?.alpha = 0.7
        }
        else{
            
            foundationRepairButton?.alpha = 0.7
            
            foundationUpgradeButton?.alpha = 1
        }
    }
    
    func hideAllMenus(){
        towerUI?.alpha = 0
        upgradeUI?.alpha = 0
        foundationUI?.alpha = 0
        towerInfoMenu?.alpha = 0
        statUpgradePopUp?.alpha = 0
        researchButton?.alpha = UIData.INACTIVE_BUTTON_ALPHA
        readyButton?.alpha = UIData.INACTIVE_BUTTON_ALPHA
    }
    
    func showSummary(){
        hideAllMenus()
        mainHubBackground?.alpha = 0
        baseHPLostNumber?.text = ("\(gameManager.baseHPLost)")
        creditsGainedNumber?.text = ("$\(gameManager.moneyEarned)")
        summaryTitle?.text = ("Wave \(gameManager.currentWave) completed!")
        researchPointsGained?.text = ("\(gameManager.researchPoints)")
        survivalBonusNumber?.text = ("\(gameManager.survivalBonusNumber)")
        
        if waveManager?.waveNumber == 10 || waveManager?.waveNumber == 20{
            bossMaterialGained?.text = "Boss Material: +1"

        } 
        
        waveSummary?.alpha = 1
    }
    
    
    private func extraButtons(nodeName: String){
        
        let communicator = GameSceneCommunicator.instance
        
        switch nodeName{
            
        case "SellTowerButton":
            GameSceneCommunicator.instance.sellTower()
            
        case "SellFoundationButton":
            
            GameSceneCommunicator.instance.sellFoundation()
            
        case "BuildFoundationButton":
            
            
            if communicator.foundationEditMode {
                communicator.confirmFoundationEdit()
                //Sound for finish foundationBuild
                //SoundManager.playSFX(sfxName: SoundManager.buttonSFX_three, scene: GameScene.instance!, sfxExtension: SoundManager.mp3Extension)
                
            }else{
                communicator.foundationEditMode = true
                communicator.toggleFoundationGrid()
                hideAllMenus()
                buildFoundationButton?.texture = SKTexture(imageNamed: "done_build_foundation_button_standard")
                //Sound for activate foundationBuild
                SoundManager.playSFX(sfxName: SoundManager.buttonSFX_two, scene: GameScene.instance!, sfxExtension: SoundManager.mp3Extension)
                
            }
            
        case "BuildTowerButton":
            print("Put TowerMenu here")
            
        case "ReadyButton":
            if readyButton?.alpha == 1{
                communicator.startWavePhase()
                fadeInPortal = true
                waveManager?.waveStartCounter = 0
                showTowerUI()
                readyButton?.alpha = UIData.INACTIVE_BUTTON_ALPHA
                researchButton?.alpha = UIData.INACTIVE_BUTTON_ALPHA
                buildFoundationButton?.alpha = UIData.INACTIVE_BUTTON_ALPHA
                upgradeMenuToggle?.alpha = 0
                SoundManager.playSFX(sfxName: SoundManager.announcer, scene: GameScene.instance!, sfxExtension: SoundManager.mp3Extension)
                GameManager.instance.moneyEarned = 0
                GameManager.instance.baseHPLost = 0
            }
            
            
            
        case "ResearchButton":
            if researchButton?.alpha == 1{
                AppManager.appManager.state = .labMenu
                SoundManager.playSFX(sfxName: SoundManager.switchToResearchRoomSFX, scene: GameScene.instance!, sfxExtension: SoundManager.mp3Extension)
                SoundManager.playBGM(bgmString: SoundManager.researchViewAtmosphere, bgmExtension: SoundManager.mp3Extension)
                
                AppManager.appManager.transitionOpacity = 1
                
                if let labScene = LabScene.instance {
                    labScene.fadeInScene = true
                }
                
            }
            
        case "BackButton":
            waveSummary?.alpha = 0
            mainHubBackground?.alpha = 1
            GameScene.instance?.readyButton?.alpha = 1
            GameScene.instance?.buildFoundationButton?.alpha = 1
            GameScene.instance?.researchButton?.alpha = 1
            GameScene.instance?.upgradeMenuToggle?.alpha = 1
            SoundManager.playSFX(sfxName: SoundManager.buttonSFX_one, scene: GameScene.instance!, sfxExtension: SoundManager.mp3Extension)
            showTowerUI()
            
            
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
            upgradeTypePreview = .firerate
            //GameSceneCommunicator.instance.upgradeTower(upgradeType: .firerate)
            
        case "RangeButton":
            upgradeTypePreview = .range
            //GameSceneCommunicator.instance.upgradeTower(upgradeType: .range)
            
        case "AttackButton":
            upgradeTypePreview = .damage
            //GameSceneCommunicator.instance.upgradeTower(upgradeType: .damage)
            
        default:
            print("error with upgrade menu")
            
        }
        
        if touchStarted == false{
            if upgradeTypePreview != nil{
                GameSceneCommunicator.instance.upgradeTower(upgradeType: upgradeTypePreview!)
                upgradeTypePreview = nil
            }
            
        }
    }
    
    
    private func dragAndDropBuild(node: SKNode, location: CGPoint) -> Bool{
        
        guard let nodeName = node.name else {return false}
        
        switch nodeName{
            
        case "GunTower":
            
            if TowerData.BASE_COST > GameManager.instance.currentMoney || !LabSceneCommunicator.instance.gunTowerResearchLevel.contains("1"){
                return false
            }
            gunTowerPrice?.alpha = 0
            displayRangeIndicator(attackRange: TowerData.ATTACK_RANGE, position: location)
            touchingTower = node as? SKSpriteNode
            touchingTower?.size = TowerData.TEXTURE_SIZE
            SoundManager.playSFX(sfxName: SoundManager.buttonOneSFX, scene: GameScene.instance!, sfxExtension: SoundManager.mp3Extension)
            
        case "SpeedTower":
            if TowerData.BASE_COST > GameManager.instance.currentMoney || !LabSceneCommunicator.instance.rapidTowerResearchLevel.contains("1"){
                return false
            }
            rapidTowerPrice?.alpha = 0
            displayRangeIndicator(attackRange: TowerData.ATTACK_RANGE * 0.5, position: location)
            touchingTower = node as? SKSpriteNode
            touchingTower?.size = TowerData.TEXTURE_SIZE
            SoundManager.playSFX(sfxName: SoundManager.buttonTwoSFX, scene: GameScene.instance!, sfxExtension: SoundManager.mp3Extension)
            
            
        case "CannonTower":
            
            if TowerData.BASE_COST > GameManager.instance.currentMoney || !LabSceneCommunicator.instance.cannonTowerResearchLevel.contains("1"){
                return false
            }
            cannonTowerPrice?.alpha = 0
            
            displayRangeIndicator(attackRange: TowerData.ATTACK_RANGE * 0.8, position: location)
            touchingTower = node as? SKSpriteNode
            touchingTower?.size = TowerData.TEXTURE_SIZE
            SoundManager.playSFX(sfxName: SoundManager.buttonThreeSFX, scene: GameScene.instance!, sfxExtension: SoundManager.mp3Extension)
            
        case "SniperTower":
            
            if TowerData.BASE_COST > GameManager.instance.currentMoney || !LabSceneCommunicator.instance.sniperTowerResearchLevel.contains("1"){
                return false
            }
            sniperTowerPrice?.alpha = 0
            
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
    
    func displayFoundationIndicator(position: CGPoint, display: Bool = true) {
        
        guard let foundationIndicator = foundationIndicator else {
            return
        }
        
        if display {
            foundationIndicator.position = position
            foundationIndicator.alpha = 0.005
            foundationIndicator.zPosition = 6
            foundationIndicatorIncrease = true
        }
        else {
            foundationIndicator.alpha = 0
        }
        
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
                AppManager.appManager.state = .gameScene
                SoundManager.playBGM(bgmString: SoundManager.ambienceOne, bgmExtension: SoundManager.mp3Extension)
            }
            
        }
        
        if touchStarted{
            handleLongPress()
        }else if statUpgradePopUp?.alpha == 1{
            statUpgradePopUp?.alpha = 0
        }
        
        if showNewMaterialMessage{
            
            for node in dialoguesNode.children{
                
                let dialog = node as! Dialogue
                dialog.update()
                
            }
            
            if dialoguesNode.children.count == 0{
                showNewMaterialMessage = false
            }
        }
        
        if GameManager.instance.isPaused || GameManager.instance.isGameOver{
            return
        }
        
        if fadeInPortal{
            fadePortal(fadeIn: true)
        }
        if fadeOutPortal{
            fadePortal(fadeIn: false)
        }
        
        if GameSceneCommunicator.instance.isBuildPhase && waveSummary?.alpha == 0{
            showBuildButtonsUI()
            //FadeoutPortal()
            //showTowerUI()
        }
        else {
            hideBuildButtonsUI()
        }
        
        if GameSceneCommunicator.instance.openDoors || GameSceneCommunicator.instance.closeDoors {
            animateDoors()
            
            if GameSceneCommunicator.instance.closeDoors {
                return
            }
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
        
        if priceTag!.alpha > 0 && touchingTower == nil{
            priceTag!.alpha -= 0.03
            priceTag!.position.y += 1.5
        }
        
        
        if moveCameraToPortal {
            let cameraDirection = PhysicsUtils.getCameraDirection(camera: self.camera!, targetPoint: portalPosition)
            PhysicsUtils.moveCameraToTargetPoint(camera: self.camera!, direction: cameraDirection)
            
            let portal = SKSpriteNode()
            portal.position = portalPosition
            portal.size = CGSize(width: 86, height: 500)
                        
            if portal.contains(camera!.position) || !EnemyNodes.enemiesNode.children.isEmpty{
                moveCameraToPortal = false
                print("Im at portal with camera")
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
        
        for node in moneyNode.children {
            
            if node is MoneyObject{
                
                let moneyObject = node as! MoneyObject
                moneyObject.update()
                
            }else if node is DropObject{
                
                let drop = node as! DropObject
                drop.update()
            }
        }
        
        if foundationIndicator!.alpha != 0 {
            
            let increaseAmount = 0.01
            let maxAlpha = 0.35
            
            if foundationIndicatorIncrease {
                foundationIndicator!.alpha += increaseAmount
                if foundationIndicator!.alpha >= maxAlpha {
                    foundationIndicator!.alpha = maxAlpha - increaseAmount
                    foundationIndicatorIncrease = false
                }
            }
            else {
                foundationIndicator!.alpha -= increaseAmount
                if foundationIndicator!.alpha <= increaseAmount {
                    foundationIndicator!.alpha = increaseAmount*2
                    foundationIndicatorIncrease = true
                }
            }
        }
        
        if !GameSceneCommunicator.instance.isBuildPhase {
            
            waveManager!.update()
            
            for node in EnemyNodes.enemiesNode.children{
                
                let enemy = node as! Enemy
                enemy.update()
            }
        }
        if showDamageIndicator{
            GameManager.instance.displayDamageIndicator()
        }
    }
    
    func fadePortal(fadeIn: Bool){
        
        let sizeDifference = CGFloat(0.01)
        
        
        if !fadeIn{
            
            if portal!.xScale >= 0{
                
                portal?.xScale -= sizeDifference
                portal?.yScale -= sizeDifference
                
                
            }
            else{
                portal!.alpha = 0
                fadeOutPortal = false
                return
            }
        }
        else{
            if portal!.alpha < 1{
                portal!.alpha = 1
            }
            
            if portal!.xScale <= 1{
                
                portal!.xScale += sizeDifference
                portal!.yScale += sizeDifference
            }
            else{
                fadeInPortal = false
                return
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
        
        //Projectile Shadows
        projectileShadowNode.removeAllChildren()
        projectileShadowNode.removeFromParent()
        
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
        
        //UI
        self.camera!.removeAllChildren()
        self.uiNode.removeFromParent()
        
        //Foundation edit mode
        clickableTileGridsNode.removeFromParent()
        
        //Money
        moneyNode.removeAllChildren()
        moneyNode.removeFromParent()
        
        dialoguesNode.removeAllChildren()
        dialoguesNode.removeFromParent()
        
        foundationIndicator!.removeFromParent()
    }
    
    func showBuildButtonsUI() {
        
        guard let buildButtonsUI = buildButtonsUI else {
            return
        }

        if buildButtonsUI.position.x <= UIData.BUILD_BUTTONS_UI_POS_X {
            return
        }
        
        buildButtonsUI.position.x -= UIData.BUILD_BUTTONS_UI_SPEED
    }
    
    func hideBuildButtonsUI() {
        
        guard let buildButtonsUI = buildButtonsUI else {
            return
        }

        if buildButtonsUI.position.x >= UIData.BUILD_BUTTONS_UI_POS_X*2 {
            return
        }
        
        buildButtonsUI.position.x += UIData.BUILD_BUTTONS_UI_SPEED
    }
    
    func panForTranslation(touch: UITouch) {
        
        if moveCameraToPortal || touchStarted{
            return
        }
        
        let positionInScene = touch.location(in: self)
        let previousPosition = touch.previousLocation(in: self)
        let translation = CGPoint(x: (positionInScene.x) - (previousPosition.x), y: (positionInScene.y) - (previousPosition.y))
        
        let position = camera!.position
        let aNewPosition = CGPoint(x: position.x - translation.x, y: position.y - translation.y)
        camera!.position = aNewPosition
    }
    
    
    @objc func pinchGestureAction(_ sender: UIPinchGestureRecognizer) {
        guard let camera = self.camera else {
            return
        }
        
        if sender.state == .began {
            
            previousCameraScale = camera.xScale
        }
        
        let newCameraScale = previousCameraScale * 1 / sender.scale
        
        if newCameraScale < 0.5 || newCameraScale > 2.3{
            
            return
            
        }
        
        camera.setScale(newCameraScale)
        setupCamera()
        
    }


    private func handleLongPress() {
       
        guard let currentTower = GameSceneCommunicator.instance.currentTower else{return}
        
        if touchStarted && upgradeTypePreview != nil{
            
            switch upgradeTypePreview{
                    
            case .damage:
                let newDmg = Double(currentTower.attackDamage) * TowerData.UPGRADE_DAMAGE_BONUS_PCT
                statUpgradePreviewText?.text = "Damage: \(currentTower.attackDamage) -> \(String(format: "%.0f", newDmg))"
            case .none:
                statUpgradePreviewText?.text = "ERROR"
            case .range:
                let newRange = Double(currentTower.attackRange) * TowerData.UPGRADE_RANGE_BONUS_PCT
                statUpgradePreviewText?.text = "Range: \(String(format: "%.0f", currentTower.attackRange)) -> \(String(format: "%.0f", newRange))"
            case .firerate:
                let newFIreRate = Double(currentTower.fireRate) * TowerData.UPGRADE_FIRE_RATE_REDUCTION_PCT
                statUpgradePreviewText?.text = "Shots per Second: \(currentTower.fireRate) -> \(String(format: "%.0f", newFIreRate))"
            }
            
            statUpgradePopUp?.alpha = 1
            
        }
    }
    
    
    
    
}

typealias tileCoordinates = (column: Int, row: Int)
