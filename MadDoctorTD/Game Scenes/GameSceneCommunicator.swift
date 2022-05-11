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
    
    func cancelFoundationBuild() {
        
        currentTile!.color = .clear
        currentTile = nil
        showFoundationMenu = false
        
    }
    
    func buildTower(type: TowerTypes){
        
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
        currentFoundation = nil
        showTowerMenu = false
        currentTile?.color = .clear
        currentTile = nil
        showFoundationMenu = false
        showUpgradeMenu = false
        currentTower = nil
    }
    
    func sellTower(){
        
        var totalPayed: Int = 0
        totalPayed += TowerData.BASE_COST
        for upgradeCount in 1...(currentTower!.upgradeCount-1) {
            let upgradeCostMultipler = Double(upgradeCount) * TowerData.COST_MULTIPLIER_PER_LEVEL
            let upgradeCost = Int(Double(TowerData.BASE_UPGRADE_COST) * upgradeCostMultipler)
            totalPayed += upgradeCost
        }
        let refund = Int(Double(totalPayed) * TowerData.REFOUND_FACTOR)
        GameManager.instance.currentMoney += refund
        
        currentTower!.builtUponFoundation!.hasTower = false
        currentTower!.removeFromParent()
        currentTower!.towerTexture.removeFromParent()
        GameScene.instance!.rangeIndicator?.removeFromParent()
        
        cancelAllMenus()
        
    }
    
    func sellFoundation(){
        
        if FoundationPlateNodes.foundationPlatesNode.children.count > 1 {
            
            let refund = Int(Double(FoundationData.BASE_COST) * FoundationData.REFOUND_FACTOR)
            GameManager.instance.currentMoney += refund
            
            currentFoundation!.builtUponTile?.containsFoundation = false
            currentFoundation!.builtUponTile = nil
            currentFoundation!.removeFromParent()
            updateFoundationPower()
            updateFoundationTexture()
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
        let startGrid2 = FoundationPlateNodes.foundationPlatesNode.children[3] as! FoundationPlate
        startGrid2.checkIfPowered(gridStart: startGrid2)
        
    }
    
    func updateFoundationTexture() {
        
        for node in FoundationPlateNodes.foundationPlatesNode.children {
            let foundationPlate = node as! FoundationPlate
            foundationPlate.updateFoundationsTexture()
        }
        
    }
    
}
