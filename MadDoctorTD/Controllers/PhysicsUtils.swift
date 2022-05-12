//
//  PhysicsUtils.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-12.
//

import Foundation
import SpriteKit

class PhysicsUtils{
    
    static func findCenterOfClosestTile(map: SKTileMapNode, object: SKNode) -> CGPoint? {
        
        let scene = GameScene.instance
        
        for row in 0..<map.numberOfRows{
            for column in 0..<map.numberOfColumns{
                
                guard let tile = scene!.tile(in: map, at: (column, row)) else {continue}

                let tilePosition = map.centerOfTile(atColumn: column, row: row)
                
                let leftSide = tilePosition.x - (tile.size.width/2)
                let topSide = tilePosition.y + (tile.size.height/2)
                let rightSide = tilePosition.x + (tile.size.width/2)
                let bottomSide = tilePosition.y - (tile.size.height/2)
                
                if object.position.x > leftSide && object.position.x < rightSide{
                    if object.position.y > bottomSide && object.position.y < topSide{
                        return tilePosition
                    }
                }
                
            }
        }
        
        return nil
    }
    
    
}
