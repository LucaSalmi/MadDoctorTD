//
//  GameSceneCommunicator.swift
//  MadDoctorTD
//
//  Created by Daniel Falkedal on 2022-05-03.
//

import Foundation

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
        
        cancelAllMenus()
        
    }
    
    func sellFoundation(){
        
        if GameScene.instance!.foundationPlatesNode.children.count > 1 {
            currentFoundation!.builtUponTile?.containsFoundation = false
            currentFoundation?.builtUponTile = nil
            currentFoundation!.removeFromParent()
        }
        
        cancelAllMenus()
    }
    
}
