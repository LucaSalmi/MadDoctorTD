//
//  ClickableTile.swift
//  MadDoctorTD
//
//  Created by Daniel Falkedal on 2022-05-03.
//

import Foundation
import SpriteKit
import SwiftUI

class ClickableTile: SKSpriteNode{
    
    var containsFoundation: Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    init(position: CGPoint){
        
        super.init(texture: nil, color: .clear, size: FoundationData.size)
        
        self.position = position
        
    }
    
    func onClick() {
        
        let gameScene = GameScene.instance!
        
        if gameScene.isWaveActive {
            return
        }
        
        if containsFoundation {
            return
        }
        
        if isPathBlocked() {
            print("Cannot build at this location. Path will be blocked!")
            return
        }
        
        var adjecentFound = false
        
        var leftPosition = position
        leftPosition.x -= DefaultTileData.size.width
        var rightPosition = position
        rightPosition.x += DefaultTileData.size.width
        var topPosition = position
        topPosition.y += DefaultTileData.size.height
        var bottomPosition = position
        bottomPosition.y -= DefaultTileData.size.height
        
        for node in gameScene.foundationPlatesNode.children {
            let currentFoundationPlate = node as! FoundationPlate
            if currentFoundationPlate.contains(leftPosition) || currentFoundationPlate.contains(rightPosition) ||
                currentFoundationPlate.contains(topPosition) || currentFoundationPlate.contains(bottomPosition) {
                
                adjecentFound = true
            }
        }
        
        if !adjecentFound {
            return
        }
        
        
        for i in 0..<gameScene.clickableTilesNode.children.count {
            
            let currentTile = gameScene.clickableTilesNode.children[i] as! ClickableTile
            
            if !currentTile.containsFoundation {
                currentTile.color = .clear
            }
            
        }
        
        color = .white
        
        let communicator = GameSceneCommunicator.instance
        communicator.currentTile = self
        communicator.showFoundationMenu = true
    }
    
    private func isPathBlocked() -> Bool {
        
        var isBlocked = false
        
        let gameScene = GameScene.instance!
        
        let testFoundation = FoundationPlate(position: self.position, tile: self)
        gameScene.foundationPlatesNode.addChild(testFoundation)
        
        let enemies = gameScene.enemiesNode.children
        
        for node in enemies {
            let enemy = node as! Enemy
            let movePoints = enemy.movePlayerToGoal()
            enemy.moving = false
            if movePoints.isEmpty {
                isBlocked = true
            }
        }
        
        gameScene.foundationPlatesNode.removeChildren(in: [testFoundation])
        
        return isBlocked
    }
    
}
