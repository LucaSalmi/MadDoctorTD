//
//  GameSceneCommunicator.swift
//  MadDoctorTD
//
//  Created by Daniel Falkedal on 2022-05-03.
//

import Foundation
import SwiftUI

class GameSceneCommunicator: ObservableObject {
    
    static let instance = GameSceneCommunicator()
    
    @Published var showFoundationMenu: Bool = false
    @Published var showTowerMenu: Bool = false
    @Published var showUpgradeMenu: Bool = false
    @Published var isBuildPhase: Bool = true
    
    var currentTile: ClickableTile? = nil
    var currentFoundation: FoundationPlate? = nil
    var currentTower: Tower? = nil
    
    private init() {}
    
    func buildFoundation() {
        
        //TODO: REMOVE/REWORK THIS METHOD
        return
        
        let price = FoundationData.BASE_COST
        if price > GameManager.instance.currentMoney {
            return
        }
        else {
            GameManager.instance.currentMoney -= price
        }
        
        currentTile!.containsFoundation = true
        currentTile!.color = .clear
        
        FoundationPlateFactory().createFoundationPlate(position: currentTile!.position, tile: currentTile!, isStartingFoundation: false)
        
        updateFoundationPower()
        updateFoundationTexture()
        
        currentTile = nil
        showFoundationMenu = false
        
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
        let nextIndexStart = FoundationPlateNodes.foundationPlatesNode.children.count / 2
        let startGrid2 = FoundationPlateNodes.foundationPlatesNode.children[nextIndexStart] as! FoundationPlate
        startGrid2.checkIfPowered(gridStart: startGrid2)
        
    }
    
    func updateFoundationTexture() {
        
        for node in FoundationPlateNodes.foundationPlatesNode.children {
            let foundationPlate = node as! FoundationPlate
            foundationPlate.updateFoundationsTexture()
        }
    }
}
