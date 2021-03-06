//
//  UIManager.swift
//  MadDoctorTD
//
//  Created by Daniel Falkedal on 2022-05-28.
//

import Foundation
import GameplayKit
import SpriteKit
import SwiftUI
import UIKit

class UIManager {
    
    var gameScene: GameScene? = nil
    
    let gameManager = GameManager.instance
    
    var previousCameraScale = CGFloat()
    
    var projectileShadowNode: SKNode = SKNode()
    var edgesTilesNode: SKNode = SKNode()
    var hpBarsNode: SKNode = SKNode()
    var towerIndicatorsNode: SKNode = SKNode()
    var foundationIndicatorsNode: SKNode = SKNode()
    
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
    
    var enemiesDefeatedNumber: SKLabelNode?
    
    var researchPointsGainedNumber: SKLabelNode?
    
    var creditsGainedNumber: SKLabelNode?
    
    var baseHPLostNumber: SKLabelNode?
    
    
    //portal
    var portal: SKTileMapNode?
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
    
    var upgradeDamagePrice: SKLabelNode?
    var upgradeSpeedPrice: SKLabelNode?
    var upgradeRangePrice: SKLabelNode?
    
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
    var moveCameraToDoors: Bool = false
    var lockCamera: Bool = false
    var zoomOutCamera: Bool = false
    
    var hideBuildMenu: Bool = false
    
    var moneyNode: SKNode = SKNode()
    
    
    
    init() {}
    
    func setupUI() {
        
        gameScene = GameScene.instance!
        
        gameScene!.addChild(uiNode)
        
        uiNode.addChild(hpBarsNode)
        uiNode.addChild(projectileShadowNode)
        uiNode.addChild(edgesTilesNode)
        
        portal = gameScene!.childNode(withName: "Tile Map Node") as? SKTileMapNode
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
        
        enemiesDefeatedNumber = waveSummary?.childNode(withName: "EnemiesDefeatedNumber") as? SKLabelNode
        
        researchPointsGainedNumber = waveSummary?.childNode(withName: "ResearchPointsGainedNumber") as? SKLabelNode
        creditsGainedNumber = waveSummary?.childNode(withName: "CreditsGainedNumber") as? SKLabelNode

        baseHPLostNumber = waveSummary?.childNode(withName: "BaseHpLostNumber") as? SKLabelNode

        survivalBonusNumber = waveSummary?.childNode(withName: "SurvivalBonusNumber") as? SKLabelNode
        

        bossMaterialGained = waveSummary?.childNode(withName: "BossMaterial") as? SKLabelNode
        researchPointsGained = waveSummary?.childNode(withName: "ResearchPointsGainedNumber") as? SKLabelNode
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
        gameScene!.camera!.addChild(waveSummary!)
        gameScene!.camera!.addChild(mainHubBackground!)
        gameScene!.camera!.addChild(foundationUI!)
        gameScene!.camera!.addChild(towerUI!)
        gameScene!.camera!.addChild(damageIndicator!)
        
        gameScene!.camera?.addChild(towerInfoMenu!)
        gameScene!.camera?.addChild(statUpgradePopUp!)
                
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
        gameScene!.camera!.addChild(buildButtonsUI!)
        
        readyButton = buildButtonsUI?.childNode(withName: "ReadyButton") as? SKSpriteNode
        
        researchButton = buildButtonsUI?.childNode(withName: "ResearchButton") as? SKSpriteNode
        
        buildFoundationButton = buildButtonsUI?.childNode(withName: "BuildFoundationButton") as? SKSpriteNode
        
        gameScene!.camera!.addChild(upgradeUI!)
        
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
        
        upgradeDamagePrice = upgradeUI?.childNode(withName: "UpgradeDamagePrice") as? SKLabelNode
        upgradeDamagePrice?.text = "$\(GameSceneCommunicator.instance.getUpgradeTowerCost())"
        upgradeSpeedPrice = upgradeUI?.childNode(withName: "UpgradeSpeedPrice") as? SKLabelNode
        upgradeSpeedPrice?.text = "$\(GameSceneCommunicator.instance.getUpgradeTowerCost())"
        upgradeRangePrice = upgradeUI?.childNode(withName: "UpgradeRangePrice") as? SKLabelNode
        upgradeRangePrice?.text = "$\(GameSceneCommunicator.instance.getUpgradeTowerCost())"
        
        uiNode.addChild(clickableTileGridsNode)
        
        uiNode.addChild(towerIndicatorsNode)
        uiNode.addChild(foundationIndicatorsNode)
        
        doorOne = gameScene!.childNode(withName: "doorOne") as! SKSpriteNode
        doorOne.position.x = gameScene!.position.x - (doorOne.size.width/2)
        doorTwo = gameScene!.childNode(withName: "doorTwo") as! SKSpriteNode
        doorTwo.position.x = gameScene!.position.x + (doorTwo.size.width/2)
        doorsAnimationCount = doorsAnimationTime
        GameSceneCommunicator.instance.closeDoors = false
        GameSceneCommunicator.instance.openDoors = true
        
        moveCameraToPortal = false
        
        uiNode.addChild(moneyNode)
        
        foundationIndicator = SKSpriteNode(texture: nil, color: .white, size: FoundationData.SIZE)
        foundationIndicator!.alpha = 0
        uiNode.addChild(foundationIndicator!)
        
    }
    
    func setupCamera(){
        
        let myCamera = gameScene!.camera
        let backgroundMap = (gameScene!.childNode(withName: "edge") as! SKTileMapNode)
        let scaledSize = CGSize(
            width: gameScene!.size.width * gameScene!.camera!.xScale,
            height: gameScene!.size.height * gameScene!.camera!.yScale
        )
        
        let xInset = min((scaledSize.width/2) - 100.0, backgroundMap.frame.width/2)
        let yInset = min((scaledSize.height/2) - 100.0, backgroundMap.frame.height/2)
        
        let constrainRect = backgroundMap.frame.insetBy(dx: xInset, dy: yInset)
        
        let yLowerLimit = constrainRect.minY
        
        let xRange = SKRange(lowerLimit: constrainRect.minX, upperLimit: constrainRect.maxX)
        let yRange = SKRange(lowerLimit: yLowerLimit, upperLimit: constrainRect.maxY)
        
        let edgeConstraint = SKConstraint.positionX(xRange, y: yRange)
        edgeConstraint.referenceNode = backgroundMap
        
        myCamera!.constraints = [edgeConstraint]
        
        if gameScene!.view?.gestureRecognizers == nil{
            
            let pinchGesture = UIPinchGestureRecognizer()
            pinchGesture.addTarget(gameScene!, action: #selector(gameScene!.pinchGestureAction(_:)))
            gameScene!.view?.addGestureRecognizer(pinchGesture)

        }
        
        myCamera!.position = CGPoint(x: 0, y: yLowerLimit)
        
    }
    
    func resetUI() {
        
        gameScene!.camera!.removeAllChildren()
        
        towerIndicatorsNode.removeAllChildren()
        towerIndicatorsNode.removeFromParent()
        
        hpBarsNode.removeAllChildren()
        hpBarsNode.removeFromParent()
        
        projectileShadowNode.removeAllChildren()
        projectileShadowNode.removeFromParent()
        
        foundationIndicatorsNode.removeAllChildren()
        foundationIndicatorsNode.removeFromParent()
        
        edgesTilesNode.removeAllChildren()
        edgesTilesNode.removeFromParent()
        
        //Foundation edit mode
        clickableTileGridsNode.removeFromParent()
        
        //Money
        moneyNode.removeAllChildren()
        moneyNode.removeFromParent()
        
        foundationIndicator!.removeFromParent()
        
        uiNode.removeAllChildren()
        uiNode.removeFromParent()
        
    }
    
    func moveTouchingTower(location: CGPoint) {
        
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
        
    }
    
    func upgradeTowerMenu(nodeName: String){
        
        switch nodeName{
            
        case "RateOfFireButton":
            upgradeTypePreview = .firerate
            
        case "RangeButton":
            upgradeTypePreview = .range
            
        case "AttackButton":
            upgradeTypePreview = .damage
            
        default:
            print("error with upgrade menu")
            
        }
        
        if gameScene!.touchStarted == false{
            if upgradeTypePreview != nil{
                GameSceneCommunicator.instance.upgradeTower(upgradeType: upgradeTypePreview!)
                upgradeTypePreview = nil
            }
            
        }
    }
    
    func movePriceTag() {
        priceTag?.position.x = touchingTower!.position.x
        priceTag?.position.y = touchingTower!.position.y + 50
        priceTag?.alpha = 1
        priceTag?.fontColor = UIColor(Color.red)
    }
    
    func updateTouchingTower() {
        
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
    
    func dragAndDropBuild(node: SKNode, location: CGPoint) -> Bool{
        
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
    
    func startTouchingTower(location: CGPoint) {
        
        priceTag?.position.x = location.x
        priceTag?.position.y = location.y - 75
        priceTag?.alpha = 1
        priceTag?.fontColor = UIColor(Color.green)
        touchingTower!.removeFromParent()
        uiNode.addChild(touchingTower!)
        touchingTower?.position = location
        
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
        
        uiNode.addChild(rangeIndicator!)
        
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
        researchPointsGained?.text = ("\(WaveData.RP_PER_WAVE)")
        survivalBonusNumber?.text = ("\(gameManager.survivalBonusNumber)")
        
        if gameManager.slimeMaterialGained > 0 {
            bossMaterialGained?.text = "Slime Material: +1"
            bossMaterialGained?.alpha = 1
        }
        else if gameManager.squidMaterialGained > 0 {
            bossMaterialGained?.text = "Squid Material: +1"
            bossMaterialGained?.alpha = 1
        }
        
        waveSummary?.alpha = 1
    }
    
    func animateDoors() {
        
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
            
            if GameSceneCommunicator.instance.closeDoors {
                GameScene.instance!.uiManager!.moveCameraToPortal = true
            }
            
            //failsafe to reset doors position to orginal position
            if GameSceneCommunicator.instance.closeDoors {
                doorOne.position.x = gameScene!.position.x - (doorOne.size.width/2)
                doorTwo.position.x = gameScene!.position.x + (doorTwo.size.width/2)
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
    
    func updateRangeIndicatorAlpha() {
        
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
    func upgradeTypePreviewUI(currentTower: Tower) {
        
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
    
    func performMoveCameraToDoors() {
        let size = CGSize(width: FoundationData.SIZE.width/6, height: FoundationData.SIZE.height/6)
        
        let targetNode = SKSpriteNode(texture: nil, color: .red, size: size)
        targetNode.alpha = 0
        targetNode.zPosition = 1000
        targetNode.position = doorOne.position
        targetNode.position.x += (doorOne.size.width + (doorOne.size.width/2) )
        targetNode.position.y += gameScene!.size.height * 0.45
        
        let cameraDirection = PhysicsUtils.getCameraDirection(camera: gameScene!.camera!, targetPoint: targetNode.position)
        PhysicsUtils.moveCameraToTargetPoint(camera: gameScene!.camera!, direction: cameraDirection)
        
        if targetNode.contains(gameScene!.camera!.position) {
            
            //Door animations
            doorsAnimationCount = doorsAnimationTime
            GameSceneCommunicator.instance.closeDoors = true
            
            
            moveCameraToDoors = false
            
        }
        
    }
    
    func performMoveCameraToPortal() {
        
        if zoomOutCamera {
            performZoomOut()
            return
        }

        let spawnPoint = gameScene!.childNode(withName: "SpawnPoint") as! SKSpriteNode
        let size = CGSize(width: FoundationData.SIZE.width/6, height: FoundationData.SIZE.height/6)
        
        let targetNode = SKSpriteNode(texture: nil, color: .red, size: size)
        targetNode.alpha = 0
        targetNode.zPosition = 1000
        targetNode.position = spawnPoint.position
        targetNode.position.y -= gameScene!.size.height * 0.2
        
        performZoomIn()
        
        let cameraDirection = PhysicsUtils.getCameraDirection(camera: gameScene!.camera!, targetPoint: targetNode.position)
        PhysicsUtils.moveCameraToTargetPoint(camera: gameScene!.camera!, direction: cameraDirection)
        
        if targetNode.contains(gameScene!.camera!.position) {
            
            zoomOutCamera = true
            onCutsceneCompleted()
            
        }
        
    }
    func performZoomIn(){
        if gameScene!.camera!.xScale > 0.6 {
            
            let scaleDecrease = 0.015
            
            gameScene!.camera!.xScale -= scaleDecrease
            gameScene!.camera!.yScale -= scaleDecrease
            
            let cameraPosition = GameScene.instance!.camera!.position
            
            setupCamera()
            GameScene.instance!.camera!.position = cameraPosition
            
        }
    }
    
    func performZoomOut() {
        
        if gameScene!.camera!.xScale < 1.3 {
            
            let scaleIncrease = 0.005
            
            gameScene!.camera!.xScale += scaleIncrease
            gameScene!.camera!.yScale += scaleIncrease
            
            let cameraPosition = GameScene.instance!.camera!.position
            setupCamera()
            GameScene.instance!.camera!.position = cameraPosition
            
        }
        else {
            zoomOutCamera = false
            lockCamera = false
        }
        
    }
    
    func onCutsceneCompleted() {
        
        print("Cut scene completed!")
        
        moveCameraToPortal = false
        
        GameSceneCommunicator.instance.startWavePhase()
        fadeInPortal = true
        gameScene!.waveManager!.waveStartCounter = 0
        showTowerUI()
        readyButton?.alpha = UIData.INACTIVE_BUTTON_ALPHA
        researchButton?.alpha = UIData.INACTIVE_BUTTON_ALPHA
        buildFoundationButton?.alpha = UIData.INACTIVE_BUTTON_ALPHA
        upgradeMenuToggle?.alpha = 0
        SoundManager.playSFX(sfxName: SoundManager.announcer, scene: GameScene.instance!, sfxExtension: SoundManager.mp3Extension)
        GameManager.instance.moneyEarned = 0
        GameManager.instance.baseHPLost = 0
        
        doorOne.position.x = 0 - doorOne.size.width/2
        doorTwo.position.x = 0 + doorTwo.size.width/2
        
    }
    
}
