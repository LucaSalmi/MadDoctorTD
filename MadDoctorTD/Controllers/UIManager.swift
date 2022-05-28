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
    
    
    var moneyNode: SKNode = SKNode()
    
    var dialoguesNode: SKNode = SKNode()
    var showNewMaterialMessage = false
    
    
    
    init() {
        
        gameScene = GameScene.instance!
        
        gameScene!.addChild(hpBarsNode)
        gameScene!.addChild(projectileShadowNode)
        gameScene!.addChild(edgesTilesNode)
        
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
        gameScene!.camera!.addChild(waveSummary!)
        gameScene!.camera!.addChild(mainHubBackground!)
        gameScene!.camera!.addChild(foundationUI!)
        gameScene!.camera!.addChild(towerUI!)
        gameScene!.camera!.addChild(damageIndicator!)
        gameScene!.addChild(uiNode)
        
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
        
        gameScene!.addChild(clickableTileGridsNode)
        
        gameScene!.addChild(towerIndicatorsNode)
        gameScene!.addChild(foundationIndicatorsNode)
        
        doorOne = gameScene!.childNode(withName: "doorOne") as! SKSpriteNode
        doorOne.position.x = gameScene!.position.x - (doorOne.size.width/2)
        doorTwo = gameScene!.childNode(withName: "doorTwo") as! SKSpriteNode
        doorTwo.position.x = gameScene!.position.x + (doorTwo.size.width/2)
        doorsAnimationCount = doorsAnimationTime
        GameSceneCommunicator.instance.closeDoors = false
        GameSceneCommunicator.instance.openDoors = true
        
        moveCameraToPortal = false
        
        gameScene!.addChild(moneyNode)
        gameScene!.addChild(dialoguesNode)
        
        foundationIndicator = SKSpriteNode(texture: nil, color: .white, size: FoundationData.SIZE)
        foundationIndicator!.alpha = 0
        gameScene!.addChild(foundationIndicator!)
        
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
        
        gameScene!.addChild(rangeIndicator!)
        
    }
    
}
