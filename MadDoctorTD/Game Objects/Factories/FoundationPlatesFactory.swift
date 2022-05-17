//
//  FoundationTilesFactory.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-10.
//

import Foundation
import SpriteKit

struct FoundationPlateNodes{
    
    static var foundationPlatesNode: SKNode = SKNode()
    
}


protocol FoundationPlatesProtocol{
    
    func createFoundationPlate(position: CGPoint, tile: ClickableTile, isStartingFoundation: Bool) -> FoundationPlate
    
}

class FoundationFactory: FoundationPlatesProtocol{
    
    func createFoundationPlate(position: CGPoint, tile: ClickableTile, isStartingFoundation: Bool) -> FoundationPlate {
        return FoundationPlate(position: position, tile: tile, isStartingFoundation: isStartingFoundation)
    }
    
}

protocol FoundationPlateCreator{
    
    func createFoundationPlate(position: CGPoint, tile: ClickableTile, isStartingFoundation: Bool)
    
}

class FoundationPlateFactory: FoundationPlateCreator{
    
    
    func createFoundationPlate(position: CGPoint, tile: ClickableTile, isStartingFoundation: Bool) {
        
        let foundation = FoundationPlate(position: position, tile: tile)
        FoundationPlateNodes.foundationPlatesNode.addChild(foundation)
        
    }
    
    
    func setupStartPlates(){
        
        FoundationPlateNodes.foundationPlatesNode.name = "FoundationPlates"
        guard let startFoundationMap = GameScene.instance!.childNode(withName: "start_foundation")as? SKTileMapNode else {
            return
        }
        
        print("map found")
        
        for row in 0..<startFoundationMap.numberOfRows{
            for column in 0..<startFoundationMap.numberOfColumns{
                
                guard let tile = GameScene.instance!.tile(in: startFoundationMap, at: (column, row)) else {continue}
                guard tile.userData?.object(forKey: "isFoundationPlate") != nil else {continue}
                
                let position = startFoundationMap.centerOfTile(atColumn: column, row: row)
                
                for node in ClickableTilesNodes.clickableTilesNode.children {
                    let clickableTile = node as! ClickableTile
                    if clickableTile.contains(position) {
                        
                        let plate = FoundationFactory().createFoundationPlate(position: position, tile: clickableTile, isStartingFoundation: true)
                        plate.updateFoundationsTexture()
                        FoundationPlateNodes.foundationPlatesNode.addChild(plate)
                    }
                }
            }
        }
        
        for node in FoundationPlateNodes.foundationPlatesNode.children {
            let foundationPlate = node as! FoundationPlate
            foundationPlate.updateFoundationsTexture()
        }
        GameSceneCommunicator.instance.secondIndexStart = FoundationPlateNodes.foundationPlatesNode.children.count/2
        //startFoundationMap.removeFromParent()
        
    }
}
