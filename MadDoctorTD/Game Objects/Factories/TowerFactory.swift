//
//  TowerFactory.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-10.
//

import Foundation
import SpriteKit


struct TowerNode {
    
    static var towersNode: SKNode = SKNode()
    static var towerTextureNode: SKNode = SKNode()
    static var towerArray = [Tower]()
    
}

protocol TowerFactoryProtocol{
    
    func createTower(currentFoundation: FoundationPlate) -> Tower
}

class GunTowerFactory: TowerFactoryProtocol{
    
    func createTower(currentFoundation: FoundationPlate) -> Tower{
        
        return GunTower(position: currentFoundation.position, foundation: currentFoundation, textureName: "gun_tower_online")
    }
}

class RapidFireTowerFactory: TowerFactoryProtocol{
    
    func createTower(currentFoundation: FoundationPlate) -> Tower{
        
        return RapidFireTower(position: currentFoundation.position, foundation: currentFoundation, textureName: "speed_tower_power_on")
    }
}

class SniperTowerFactory: TowerFactoryProtocol{
    
    func createTower(currentFoundation: FoundationPlate) -> Tower{
        
        return SniperTower(position: currentFoundation.position, foundation: currentFoundation, textureName: "sniper_tower_power_on")
    }
}


protocol TowerCreator{
    
    func createTower(currentFoundation: FoundationPlate)
    
}
    
    class TowerFactory: TowerCreator{
        
        var type : TowerTypes
        
        init(towerType: TowerTypes){
            self.type = towerType
        }
        
        func createTower(currentFoundation: FoundationPlate){
            
            switch type {
                
            case .gunTower:
                
                let tower = GunTowerFactory().createTower(currentFoundation: currentFoundation)
                TowerNode.towersNode.addChild(tower)
                TowerNode.towerTextureNode.addChild(tower.towerTexture)
                TowerNode.towerArray.append(tower)
                
            case .rapidFireTower:
                
                let tower = RapidFireTowerFactory().createTower(currentFoundation: currentFoundation)
                TowerNode.towersNode.addChild(tower)
                TowerNode.towerTextureNode.addChild(tower.towerTexture)
                TowerNode.towerArray.append(tower)
                
            case .sniperTower:
                
                let tower = SniperTowerFactory().createTower(currentFoundation: currentFoundation)
                TowerNode.towersNode.addChild(tower)
                TowerNode.towerTextureNode.addChild(tower.towerTexture)
                TowerNode.towerArray.append(tower)
                
            }
        }
    }
