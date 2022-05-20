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
    
    @Published var foundationEditMode: Bool = false
    var foundationDeleteMode = false
    var blueprints = [FoundationPlate]()
    var secondIndexStart: Int = 6
    
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
            return
        }
        
        if isPathBlocked() {
            print("Path is blocked")
            return
        }
        
        updateFoundationPower()
        for blueprint in blueprints {
            if !blueprint.isPowered {
                print("Some blueprints are not connected")
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
            if touchedNode is ClickableTile {
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
        
        let missingHp: Int = currentFoundation!.maxHp - currentFoundation!.hp
        
        let price: Int = Int(Double(missingHp) * FoundationData.REPAIR_PRICE_PER_HP)
        
        if price > GameManager.instance.currentMoney  {
            return
        }
        
        GameManager.instance.currentMoney -= price
        currentFoundation!.hp = currentFoundation!.maxHp
        
        currentFoundation!.warningTexture!.alpha = 0
        currentFoundation!.crackTexture!.alpha = 0
    }
    
    func upgradeFoundation() {
        
        if currentFoundation!.isStartingFoundation {
            return
        }
        
        if FoundationData.UPGRADE_PRICE > GameManager.instance.currentMoney {
            return
        }
        
        if currentFoundation!.hp < currentFoundation!.maxHp {
            return
        }
        
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
    
    func upgradeTower(upgradeType: UpgradeTypes) {
        
        
        GameScene.instance?.displayRangeIndicator(attackRange: currentTower!.attackRange, position: currentTower!.position)
        
        if currentTower!.upgradeCount > TowerData.MAX_UPGRADE{
            return
        }
        
        let upgradeCostMultipler = Double(currentTower!.upgradeCount) * TowerData.COST_MULTIPLIER_PER_LEVEL
        let upgradeCost = Int(Double(TowerData.BASE_UPGRADE_COST) * upgradeCostMultipler)
        
        if upgradeCost > GameManager.instance.currentMoney {
            return
        }
        else {
            GameManager.instance.currentMoney -= upgradeCost
        }
        
        switch upgradeType {
        case .damage:
            currentTower!.upgrade(upgradeType: .damage)
        case .range:
            currentTower!.upgrade(upgradeType: .range)
        case .firerate:
            currentTower!.upgrade(upgradeType: .firerate)
        }
        
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
        
        GameScene.instance!.rangeIndicator?.removeFromParent()
        
        cancelAllMenus()
        
    }
    
    func sellFoundation(){
        
        if FoundationPlateNodes.foundationPlatesNode.children.count > 1 {
            
            let refund = Int(Double(FoundationData.BASE_COST) * FoundationData.REFOUND_FACTOR)
            GameManager.instance.currentMoney += refund
            
            currentFoundation?.onDestroy()
            
        }
        
        cancelAllMenus()
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
        
        for node in GameScene.instance!.clickableTileGridsNode.children {

            let gridTexture = node as! SKSpriteNode
            
            if foundationEditMode {
                gridTexture.alpha = 1
            }
            else {
                gridTexture.alpha = 0
            }
        }
        
    }
    
    
}
