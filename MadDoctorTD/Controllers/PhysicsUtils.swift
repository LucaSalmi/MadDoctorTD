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
    
    static func moveCameraToTargetPoint(camera: SKCameraNode, direction: CGPoint) {
        
        //let direction = PhysicsUtils.getCameraDirection(camera: camera, targetPoint: targetPoint)
        
        let speed: CGFloat = CGFloat(15.0)
        
        camera.position.x += (speed * direction.x)
        camera.position.y += (speed * direction.y)
        
    }
    
    static func getCameraDirection(camera: SKCameraNode, targetPoint: CGPoint) -> CGPoint {
        
        
        
        var differenceX = targetPoint.x - camera.position.x
        var differenceY = targetPoint.y - camera.position.y
        
        var isNegativeX = false
        if differenceX < 0 {
            isNegativeX = true
            differenceX *= -1
        }
        
        var isNegativeY = false
        if differenceY < 0 {
            isNegativeY = true
            differenceY *= -1
        }
        
        let differenceH = sqrt((differenceX*differenceX) + (differenceY*differenceY))
        
        differenceX /= differenceH
        differenceY /= differenceH
        
        if isNegativeX {
            differenceX *= -1
        }
        if isNegativeY {
            differenceY *= -1
        }
        
        let directionX = differenceX
        let directionY = differenceY
        
        return CGPoint(x: directionX, y: directionY)
        
    }
    
}
