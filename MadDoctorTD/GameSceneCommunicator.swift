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
    
    var currentTile: ClickableTile? = nil
    var currentFoundation: FoundationPlate? = nil
    
    
    
    
    private init() {}
    
    func buildFoundation() {
        
        currentTile!.containsFoundation = true
        currentTile!.color = .clear
        
        
        let foundation = FoundationPlate(position: currentTile!.position)
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
            let gunTower = GunTower(position: currentFoundation!.position)
            GameScene.instance!.towersNode.addChild(gunTower)
        
        default:
            print("Error building tower")
        }
        
        hideTowerBuild()
        
        
    }
    
    func hideTowerBuild(){
        currentFoundation = nil
        showTowerMenu = false
    }
    
    func cancelAllMenus(){
        currentFoundation = nil
        showTowerMenu = false
        currentTile?.color = .clear
        currentTile = nil
        showFoundationMenu = false
    }
    
}
