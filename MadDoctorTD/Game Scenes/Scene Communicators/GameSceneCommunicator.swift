//
//  GameSceneCommunicator.swift
//  MadDoctorTD
//
//  Created by Daniel Falkedal on 2022-05-03.
//

import Foundation
import SwiftUI
import SpriteKit

class GameSceneCommunicator: ObservableObject {
    
    static let instance = GameSceneCommunicator()
    
    @Published var showFoundationMenu: Bool = false
    @Published var showTowerMenu: Bool = false
    @Published var showUpgradeMenu: Bool = false
    @Published var isBuildPhase: Bool = true
    
    var showUpgradeMenuUI: Bool = false
    var showTowerMenuUI: Bool = false
    
    var currentTile: ClickableTile? = nil
    var currentFoundation: FoundationPlate? = nil
    var currentTower: Tower? = nil
    var canBuild: Bool = false
    
    @Published var foundationEditMode: Bool = false
    var foundationDeleteMode = false
    var blueprints = [FoundationPlate]()
    var secondIndexStart: Int = 0 //This variable is set at Start Foundation Setup (in FoundationPlatesFactory.setupStartPlates()-method)
    
    @Published var newFoundationTotalCost: Int = 0
    
    @Published var openDoors: Bool = false
    @Published var closeDoors: Bool = false
    
    private init() {}
    
    func confirmFoundationEdit() {
        
        //let totalPrice = foundationsToAdd.count * FoundationData.BASE_COST
        //GameManager.instance.currentMoney -= totalPrice
        //foundationsToAdd.removeAll()
        
        if newFoundationTotalCost > GameManager.instance.currentMoney {

            print("Too expensive")

            SoundManager.playSFX(sfxName: SoundManager.errorSound, scene: GameScene.instance!, sfxExtension: SoundManager.wavExtension)

            return
        }
        
        if isPathBlocked() {
            print("Path is blocked")
            SoundManager.playSFX(sfxName: SoundManager.errorSound, scene: GameScene.instance!, sfxExtension: SoundManager.wavExtension)

            return
        }
        
        updateFoundationPower()
        for blueprint in blueprints {
            if !blueprint.isPowered {
                print("Some blueprints are not connected")
                SoundManager.playSFX(sfxName: SoundManager.errorSound, scene: GameScene.instance!, sfxExtension: SoundManager.wavExtension)
                return
            }
        }
        
        for blueprint in blueprints {
            blueprint.alpha = 1
        }
        blueprints.removeAll()
        
        for clickNode in ClickableTilesNodes.clickableTilesNode.children {
            let clickableTile = clickNode as! ClickableTile
            clickableTile.containsBlueprint = nil
        }
        
        GameManager.instance.currentMoney -= newFoundationTotalCost
        newFoundationTotalCost = 0
        
        updateFoundationTexture()
        
        foundationEditMode = false
        toggleFoundationGrid()
        GameScene.instance!.uiManager!.showTowerUI()
        GameScene.instance!.uiManager!.readyButton?.alpha = 1
        GameScene.instance!.uiManager!.researchButton?.alpha = 1
        GameScene.instance!.uiManager!.buildFoundationButton?.texture = SKTexture(imageNamed: "build_foundation_button_standard")

        SoundManager.playSFX(sfxName: SoundManager.buttonSFX_three, scene: GameScene.instance!, sfxExtension: SoundManager.mp3Extension)
    }
    
    private func isPathBlocked() -> Bool {
        
        var isBlocked = false
        
        let gameScene = GameScene.instance!
        
        let enemy = gameScene.pathfindingTestEnemy!
        let movePoints = enemy.getMovePoints()
        if movePoints.isEmpty {
            isBlocked = true
        }
        else {
            enemy.movePoints = movePoints
            print("Enemy movepoints = \(enemy.movePoints.count)")
        }
        
        return isBlocked
    }
    
    func editFoundationTouchMove(touchedNodes: [SKNode]) {
        
        for touchedNode in touchedNodes {
            
            if touchedNode is FoundationPlate {
                let foundation = touchedNode as! FoundationPlate
                if foundation.alpha == 1 {
                    break
                }
            }
            else if touchedNode is ClickableTile {
                let clickableTile = touchedNode as! ClickableTile
                clickableTile.onClick()
                break
            }
        }
        
    }
    
    func editFoundationTouchStart(touchedNodes: [SKNode]) {
        
        foundationDeleteMode = false
        
        for node in touchedNodes {
            
            if node is FoundationPlate {
                foundationDeleteMode = true
                print("delete = true")
                break
            }
        }
        
        editFoundationTouchMove(touchedNodes: touchedNodes)
        
    }
    
    func repairFoundation() {
        GameScene.instance!.uiManager!.displayFoundationIndicator(position: currentFoundation!.position)
        
        let missingHp: Int = currentFoundation!.maxHp - currentFoundation!.hp
        
        let price: Int = Int(Double(missingHp) * FoundationData.REPAIR_PRICE_PER_HP)
        
        if price > GameManager.instance.currentMoney  {
            return
        }
        
        GameManager.instance.currentMoney -= price
        currentFoundation!.hp = currentFoundation!.maxHp
        
        currentFoundation!.warningTexture!.alpha = 0
        currentFoundation!.crackTexture!.alpha = 0
        GameScene.instance!.uiManager!.foundationUpgradeButton?.alpha = 1
        GameScene.instance!.uiManager!.foundationRepairButton?.alpha = 0.7
        
    }
    
    func upgradeFoundation() {
        
        
        
        if currentFoundation!.isStartingFoundation {
            return
        }
        GameScene.instance!.uiManager!.displayFoundationIndicator(position: currentFoundation!.position)
        
        if FoundationData.UPGRADE_PRICE > GameManager.instance.currentMoney {
            return
        }
        
        if currentFoundation!.hp < currentFoundation!.maxHp {
            return
        }
        
        if currentFoundation!.upgradeLevel >= FoundationData.MAX_UPGRADE {
            return
        }
        
        currentFoundation!.upgradeLevel += 1
        currentFoundation!.updateUpgradeButtonTexture()
        
        currentFoundation!.maxHp = Int( Double(currentFoundation!.maxHp) * FoundationData.UPGRADE_HP_FACTOR )
        
        currentFoundation!.hp = currentFoundation!.maxHp
        GameManager.instance.currentMoney -= FoundationData.UPGRADE_PRICE
        
    }
    
    func cancelFoundationBuild() {
        
        currentTile!.color = .clear
        currentTile = nil
        showFoundationMenu = false
        
    }
    
    func buildTower(type: TowerTypes){
        
        SoundManager.playSFX(sfxName: SoundManager.buildingPlacementSFX, scene: GameScene.instance!)
        
        let price = TowerData.BASE_COST
        if price > GameManager.instance.currentMoney {
            return
        }
        else {
            GameManager.instance.currentMoney -= price
        }
        
        currentFoundation!.hasTower = true
        TowerFactory(towerType: type).createTower(currentFoundation: currentFoundation!)
        cancelAllMenus()
        
    }
    
    func getUpgradeTowerCost() -> Int {
        
        var upgradeCostMultipler = Double(1) * TowerData.COST_MULTIPLIER_PER_LEVEL
        
        if let currentTower = currentTower {
            upgradeCostMultipler = Double(currentTower.upgradeCount) * TowerData.COST_MULTIPLIER_PER_LEVEL
        }
        
        let upgradeCost = Int(Double(TowerData.BASE_UPGRADE_COST) * upgradeCostMultipler)
        
        return upgradeCost
    }
    
    func upgradeTower(upgradeType: UpgradeTypes) {
        
        GameScene.instance?.uiManager!.displayRangeIndicator(attackRange: currentTower!.attackRange, position: currentTower!.position)
        
        if currentTower!.upgradeCount > TowerData.MAX_UPGRADE{
            return
        }
        let upgradeCost = getUpgradeTowerCost()
        
        if upgradeCost > GameManager.instance.currentMoney {
            return
        }
        
        if !validateTowerResearch(upgradeType: upgradeType) {
            return
        }
        
        currentTower!.upgrade(upgradeType: upgradeType)
        
        /*
        switch upgradeType {
        case .damage:
            currentTower!.upgrade(upgradeType: .damage)
        case .range:
            currentTower!.upgrade(upgradeType: .range)
        case .firerate:
            currentTower!.upgrade(upgradeType: .firerate)
        }
         */
        
        GameManager.instance.currentMoney -= upgradeCost
        
    }
    
    private func validateTowerResearch(upgradeType: UpgradeTypes) -> Bool {
        
        switch upgradeType {
        case .damage:
            
            //Towers are currently capped at level 3 on individual upgrades
            if currentTower!.damageUpgradeCount >= 3 {
                return false
            }
            
            //Base upgrade
            if currentTower! is GunTower && currentTower!.damageUpgradeCount == 1 && !LabSceneCommunicator.instance.gunTowerResearchLevel.contains("2a") {
                return false
            }
            if currentTower! is RapidFireTower && currentTower!.damageUpgradeCount == 1 && !LabSceneCommunicator.instance.rapidTowerResearchLevel.contains("2a") {
                return false
            }
            if currentTower! is SniperTower && currentTower!.damageUpgradeCount == 1 && !LabSceneCommunicator.instance.sniperTowerResearchLevel.contains("2a") {
                return false
            }
            if currentTower! is CannonTower && currentTower!.damageUpgradeCount == 1 && !LabSceneCommunicator.instance.cannonTowerResearchLevel.contains("2a") {
                return false
            }
            
            //Material upgrade
            if currentTower! is GunTower && currentTower!.damageUpgradeCount == 2 && !LabSceneCommunicator.instance.gunTowerResearchLevel.contains("3a") {
                return false
            }
            else if currentTower! is GunTower && currentTower!.damageUpgradeCount == 2 {
                let gunTower = currentTower! as! GunTower
                gunTower.activateBouncingProjectiles()
            }
            if currentTower! is RapidFireTower && currentTower!.damageUpgradeCount == 2 {
                return false
            }
            else if currentTower! is RapidFireTower && currentTower!.damageUpgradeCount == 2 {
                //material upgrade goes here
            }
            if currentTower! is SniperTower && currentTower!.damageUpgradeCount == 2 {
                return false
            }
            else if currentTower! is SniperTower && currentTower!.damageUpgradeCount == 2 {
                //material upgrade goes here
            }
            if currentTower! is CannonTower && currentTower!.damageUpgradeCount == 2 {
                return false
            }
            else if currentTower! is CannonTower && currentTower!.damageUpgradeCount == 2 {
                //material upgrade goes here
            }
            
        case .range:
            
            //Towers are currently capped at level 3 on individual upgrades
            if currentTower!.rangeUpgradeCount >= 3 {
                return false
            }
            
            //Base upgrade
            if currentTower! is GunTower && currentTower!.rangeUpgradeCount == 1 && !LabSceneCommunicator.instance.gunTowerResearchLevel.contains("2c") {
                return false
            }
            if currentTower! is RapidFireTower && currentTower!.rangeUpgradeCount == 1 && !LabSceneCommunicator.instance.rapidTowerResearchLevel.contains("2c") {
                return false
            }
            if currentTower! is SniperTower && currentTower!.rangeUpgradeCount == 1 && !LabSceneCommunicator.instance.sniperTowerResearchLevel.contains("2c") {
                return false
            }
            if currentTower! is CannonTower && currentTower!.rangeUpgradeCount == 1 && !LabSceneCommunicator.instance.cannonTowerResearchLevel.contains("2c") {
                return false
            }
            
            //Material upgrade
            if currentTower! is GunTower && currentTower!.rangeUpgradeCount == 2 {
                return false
            }
            else if currentTower! is GunTower && currentTower!.rangeUpgradeCount == 2 {
                //material upgrade goes here
            }
            if currentTower! is RapidFireTower && currentTower!.rangeUpgradeCount == 2 {
                return false
            }
            else if currentTower! is RapidFireTower && currentTower!.rangeUpgradeCount == 2 {
                //material upgrade goes here
            }
            if currentTower! is SniperTower && currentTower!.rangeUpgradeCount == 2 {
                return false
            }
            else if currentTower! is SniperTower && currentTower!.rangeUpgradeCount == 2 {
                //material upgrade goes here
            }
            if currentTower! is CannonTower && currentTower!.rangeUpgradeCount == 2 && !LabSceneCommunicator.instance.cannonTowerResearchLevel.contains("3c") {
                return false
            }
            else if currentTower! is CannonTower && currentTower!.rangeUpgradeCount == 2 {
                let cannonTower = currentTower! as! CannonTower
                cannonTower.activateMineProjectiles()
            }
            
        case .firerate:
            
            //Towers are currently capped at level 3 on individual upgrades
            if currentTower!.rateOfFireUpgradeCount >= 3 {
                return false
            }
            
            //Base upgrade
            if currentTower! is GunTower && currentTower!.rateOfFireUpgradeCount == 1 && !LabSceneCommunicator.instance.gunTowerResearchLevel.contains("2b") {
                return false
            }
            if currentTower! is RapidFireTower && currentTower!.rateOfFireUpgradeCount == 1 && !LabSceneCommunicator.instance.rapidTowerResearchLevel.contains("2b") {
                return false
            }
            if currentTower! is SniperTower && currentTower!.rateOfFireUpgradeCount == 1 && !LabSceneCommunicator.instance.sniperTowerResearchLevel.contains("2b") {
                return false
            }
            if currentTower! is CannonTower && currentTower!.rateOfFireUpgradeCount == 1 && !LabSceneCommunicator.instance.cannonTowerResearchLevel.contains("2b") {
                return false
            }
            
            //Material upgrade
            if currentTower! is GunTower && currentTower!.rateOfFireUpgradeCount == 2 {
                return false
            }
            else if currentTower! is GunTower && currentTower!.rateOfFireUpgradeCount == 2 {
                //material upgrade goes here
            }
            if currentTower! is RapidFireTower && currentTower!.rateOfFireUpgradeCount == 2 && !LabSceneCommunicator.instance.rapidTowerResearchLevel.contains("3b") {
                return false
            }
            else if currentTower! is RapidFireTower && currentTower!.rateOfFireUpgradeCount == 2 {
                let rapidFireTower = currentTower! as! RapidFireTower
                rapidFireTower.activateSlowProjectiles()
            }
            if currentTower! is SniperTower && currentTower!.rateOfFireUpgradeCount == 2 && !LabSceneCommunicator.instance.sniperTowerResearchLevel.contains("3b") {
                return false
            }
            else if currentTower! is SniperTower && currentTower!.rateOfFireUpgradeCount == 2 {
                let sniperTower = currentTower! as! SniperTower
                sniperTower.activatePosionProjectile()
            }
            if currentTower! is CannonTower && currentTower!.rateOfFireUpgradeCount == 2 {
                return false
            }
            else if currentTower! is CannonTower && currentTower!.rateOfFireUpgradeCount == 2 {
                //material upgrade goes here
            }
            
        }
        
        return true
    }

    func cancelAllMenus(){
        //currentFoundation = nil
        showTowerMenu = false
        currentTile?.color = .clear
        //currentTile = nil
        showFoundationMenu = false
        showUpgradeMenu = false
        //currentTower = nil
    }
    
    func sellTower(){
        
        var totalPayed: Int = 0
        totalPayed += TowerData.BASE_COST
        if currentTower!.upgradeCount > 1{
            
            for upgradeCount in 1...(currentTower!.upgradeCount - 1) {
                
                let upgradeCostMultipler = Double(upgradeCount) * TowerData.COST_MULTIPLIER_PER_LEVEL
                let upgradeCost = Int(Double(TowerData.BASE_UPGRADE_COST) * upgradeCostMultipler)
                totalPayed += upgradeCost
            }
        }
        
        let refund = Int(Double(totalPayed) * TowerData.REFOUND_FACTOR)
        GameManager.instance.currentMoney += refund
        
        currentTower!.builtUponFoundation!.hasTower = false
        currentTower!.removeFromParent()
        currentTower!.towerTexture.removeFromParent()
        currentTower?.noPowerTexture.removeFromParent()
        
        if currentTower! is SniperTower{
            let sniperTower = currentTower as! SniperTower
            sniperTower.sniperLegs.removeFromParent()
        }
        
        GameScene.instance!.uiManager!.rangeIndicator?.removeFromParent()
        
        cancelAllMenus()
        
    }
    
    func sellFoundation(){
        
        if FoundationPlateNodes.foundationPlatesNode.children.count > 1 {
            
            let refund = Int(Double(FoundationData.BASE_COST) * FoundationData.REFOUND_FACTOR)
            GameManager.instance.currentMoney += refund
            
            currentFoundation?.onDestroy()
            
        }
        
        
        GameScene.instance?.uiManager!.showTowerUI()
        cancelAllMenus()
    }
    
    
    func startWavePhase() {
        
        let gameScene = GameScene.instance!
        
        gameScene.waveManager!.waveStartCounter = WaveData.WAVE_START_TIME
        GameSceneCommunicator.instance.isBuildPhase = false
        gameScene.waveManager!.shouldCreateWave = true
        GameSceneCommunicator.instance.cancelAllMenus()
        //SoundManager.playBGM(bgmString: SoundManager.desertAmbience, bgmExtension: SoundManager.mp3Extension)
        
    }
    
    
    func updateFoundationPower() {
        
        for node in FoundationPlateNodes.foundationPlatesNode.children {
            let foundationPlate = node as! FoundationPlate
            foundationPlate.isPowered = false
            foundationPlate.isPoweredChecked = false
        }
        
        let startGrid1 = FoundationPlateNodes.foundationPlatesNode.children[0] as! FoundationPlate
        startGrid1.checkIfPowered(gridStart: startGrid1)
        let startGrid2 = FoundationPlateNodes.foundationPlatesNode.children[secondIndexStart] as! FoundationPlate
        startGrid2.checkIfPowered(gridStart: startGrid2)
        
    }
    
    func updateFoundationTexture() {
        
        for node in FoundationPlateNodes.foundationPlatesNode.children {
            let foundationPlate = node as! FoundationPlate
            foundationPlate.updateFoundationsTexture()
        }
    }
    
    func toggleFoundationGrid() {
        
        for node in GameScene.instance!.uiManager!.clickableTileGridsNode.children {

            let gridTexture = node as! SKSpriteNode
            
            if foundationEditMode {
                gridTexture.alpha = 0.1
            }
            else {
                gridTexture.alpha = 0
            }
        }
        
    }
    
    
}
