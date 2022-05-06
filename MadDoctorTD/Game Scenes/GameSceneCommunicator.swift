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
    
    var currentTile: ClickableTile? = nil
    var currentFoundation: FoundationPlate? = nil
    var currentTower: Tower? = nil
    
    
    
    
    private init() {}
    
    func buildFoundation() {
        
        currentTile!.containsFoundation = true
        currentTile!.color = .clear
        
        
        let foundation = FoundationPlate(position: currentTile!.position, tile: currentTile!)
        GameScene.instance!.foundationPlatesNode.addChild(foundation)
        
        updateFoundationPower()
        foundation.updateFoundationsTexture(isCenterFoundation: true)
        
        currentTile = nil
        showFoundationMenu = false
        
    }
    
    func cancelFoundationBuild() {
        
        currentTile!.color = .clear
        currentTile = nil
        showFoundationMenu = false
        
    }
    
    func buildTower(type: Int){
        
        currentFoundation!.hasTower = true
        switch type{
        
        case TowerTypes.gunTower.rawValue:
            let gunTower = GunTower(position: currentFoundation!.position, foundation: currentFoundation!, textureName: "gun_tower_online")
            GameScene.instance!.towersNode.addChild(gunTower)
            GameScene.instance!.addChild(gunTower.towerTexture)
        
        default:
            print("Error building tower")
        }
        
        cancelAllMenus()
        
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
        
        currentTower!.builtUponFoundation?.hasTower = false
        currentTower!.removeFromParent()
        currentTower?.towerTexture.removeFromParent()
        GameScene.instance?.rangeIndicator?.removeFromParent()
        
        cancelAllMenus()
        
    }
    
    func sellFoundation(){
        
        if GameScene.instance!.foundationPlatesNode.children.count > 1 {
            currentFoundation!.builtUponTile?.containsFoundation = false
            currentFoundation!.builtUponTile = nil
            currentFoundation!.removeFromParent()
            updateFoundationPower()
            currentFoundation!.updateFoundationsTexture(isCenterFoundation: true, isSelling: true)
        }
        
        cancelAllMenus()
    }
    
    func updateFoundationPower() {
        
        let gameScene = GameScene.instance!
        
        for node in gameScene.foundationPlatesNode.children {
            let foundationPlate = node as! FoundationPlate
            foundationPlate.isPowered = false
            foundationPlate.isPoweredChecked = false
        }
        
        let startGrid1 = gameScene.foundationPlatesNode.children[0] as! FoundationPlate
        startGrid1.checkIfPowered(gridStart: startGrid1)
        let startGrid2 = gameScene.foundationPlatesNode.children[3] as! FoundationPlate
        startGrid2.checkIfPowered(gridStart: startGrid2)
        
    }
    
}
