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
        
        super.init(texture: nil, color: .clear, size: FoundationData.SIZE)
        
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
        leftPosition.x -= DefaultTileData.SIZE.width
        var rightPosition = position
        rightPosition.x += DefaultTileData.SIZE.width
        var topPosition = position
        topPosition.y += DefaultTileData.SIZE.height
        var bottomPosition = position
        bottomPosition.y -= DefaultTileData.SIZE.height
        
        for node in FoundationPlateNodes.foundationPlatesNode.children {
            let currentFoundationPlate = node as! FoundationPlate
            if currentFoundationPlate.contains(leftPosition) || currentFoundationPlate.contains(rightPosition) ||
                currentFoundationPlate.contains(topPosition) || currentFoundationPlate.contains(bottomPosition) {
                
                adjecentFound = true
            }
        }
        
        if !adjecentFound {
            return
        }
        
        
        for i in 0..<ClickableTilesNodes.clickableTilesNode.children.count {
            
            let currentTile = ClickableTilesNodes.clickableTilesNode.children[i] as! ClickableTile
            
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
        FoundationPlateNodes.foundationPlatesNode.addChild(testFoundation)
        
        let enemy = gameScene.pathfindingTestEnemy!
        let movePoints = enemy.getMovePoints()
        if movePoints.isEmpty {
            isBlocked = true
        }
        else {
            enemy.movePoints = movePoints
            print("Enemy movepoints = \(enemy.movePoints.count)")
        }
        
        FoundationPlateNodes.foundationPlatesNode.removeChildren(in: [testFoundation])
        
        return isBlocked
    }
}
