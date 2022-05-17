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
    
    var gridTexture: SKSpriteNode!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    init(position: CGPoint){
        
        super.init(texture: nil, color: .clear, size: FoundationData.SIZE)
        
        self.position = position
        
        gridTexture = SKSpriteNode(imageNamed: "foundation_grid")
        gridTexture.alpha = 0
        gridTexture.zPosition = self.zPosition + 1
        gridTexture.position = position
        GameScene.instance!.clickableTileGridsNode.addChild(gridTexture)
        
    }
    
    func onClick() {
        
        if !GameSceneCommunicator.instance.isBuildPhase {
            return
        }
        
        if containsFoundation {
            return
        }
        
        if FoundationData.BASE_COST > GameManager.instance.currentMoney {
            print("Can not afford")
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
            
            if !currentFoundationPlate.isPowered {
                continue
            }
            
            if currentFoundationPlate.contains(leftPosition) || currentFoundationPlate.contains(rightPosition) ||
                currentFoundationPlate.contains(topPosition) || currentFoundationPlate.contains(bottomPosition) {
                adjecentFound = true
                break
            }
        }
        
        if !adjecentFound {
            return
        }
        
        //Old code:
        /*
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
         */
        
        
        containsFoundation = true
        FoundationPlateFactory().createFoundationPlate(position: self.position, tile: self, isStartingFoundation: false)
        
        updateFoundationPower()
        updateFoundationTexture()
        
        GameManager.instance.currentMoney -= FoundationData.BASE_COST

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
    
    func updateFoundationPower() {
        
        for node in FoundationPlateNodes.foundationPlatesNode.children {
            let foundationPlate = node as! FoundationPlate
            foundationPlate.isPowered = false
            foundationPlate.isPoweredChecked = false
        }
        
        let startGrid1 = FoundationPlateNodes.foundationPlatesNode.children[0] as! FoundationPlate
        startGrid1.checkIfPowered(gridStart: startGrid1)
        let startGrid2 = FoundationPlateNodes.foundationPlatesNode.children[GameSceneCommunicator.instance.secondIndexStart] as! FoundationPlate
        startGrid2.checkIfPowered(gridStart: startGrid2)
        
    }
    
    func updateFoundationTexture() {
        
        for node in FoundationPlateNodes.foundationPlatesNode.children {
            let foundationPlate = node as! FoundationPlate
            foundationPlate.updateFoundationsTexture()
        }
    }
}
