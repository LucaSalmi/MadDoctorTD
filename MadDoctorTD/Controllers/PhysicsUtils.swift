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
    
    static func shakeCamera(duration: CGFloat) {
        
        guard let scene = GameScene.instance else {return}
        
        let amplitudeX: CGFloat = 10;
        let amplitudeY: CGFloat = 6;
        let numberOfShakes = duration / 0.04;
        var actionsArray = [SKAction]();
        for _ in 1...Int(numberOfShakes) {
            // build a new random shake and add it to the list
            let moveX = CGFloat(arc4random_uniform(UInt32(amplitudeX))) - amplitudeX / 2;
            let moveY = CGFloat(arc4random_uniform(UInt32(amplitudeY))) - amplitudeY / 2;
            let shakeAction = SKAction.moveBy(x: moveX, y: moveY, duration: 0.02);
            shakeAction.timingMode = SKActionTimingMode.easeOut;
            actionsArray.append(shakeAction);
            actionsArray.append(shakeAction.reversed());
        }

        let actionSeq = SKAction.sequence(actionsArray);
        
        scene.camera?.run(actionSeq)

    }
    
}
