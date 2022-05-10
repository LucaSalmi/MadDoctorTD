//
//  ClickableTilesFatory.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-10.
//

import Foundation
import SpriteKit

struct ClickableTilesNodes{
    
    static var clickableTilesNode: SKNode = SKNode()
    
}

protocol clickableTileProtocol{
    
    func createClickableTile(position: CGPoint) -> ClickableTile
    
}

class TileFactory: clickableTileProtocol{
    
    func createClickableTile(position: CGPoint) -> ClickableTile {
        return ClickableTile(position: position)
    }
    
}

protocol ClickableTileCreator{
    
    func createClickableTile(position: CGPoint)
    
}

class ClickableTileFactory: ClickableTileCreator{
    
    init(){
        
        guard let clickableTileMap = GameScene.instance!.childNode(withName: "clickable_tiles")as? SKTileMapNode else {
            return
        }
        
        for row in 0..<clickableTileMap.numberOfRows{
            for column in 0..<clickableTileMap.numberOfColumns{
                
                guard let tile = GameScene.instance!.tile(in: clickableTileMap, at: (column, row)) else {continue}
                guard tile.userData?.object(forKey: "isClickableTile") != nil else {continue}
                
                createClickableTile(position: clickableTileMap.centerOfTile(atColumn: column, row: row))
 
            }
        }
        
        ClickableTilesNodes.clickableTilesNode.name = "ClickableTiles"
        clickableTileMap.removeFromParent()
        
    }
    
    func createClickableTile(position: CGPoint) {
        let tile = TileFactory().createClickableTile(position: position)
        ClickableTilesNodes.clickableTilesNode.addChild(tile)
    }
    
}
