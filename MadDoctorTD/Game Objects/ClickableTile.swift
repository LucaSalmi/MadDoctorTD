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
    var containsBlueprint: FoundationPlate? = nil
    
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
        
        if GameSceneCommunicator.instance.foundationDeleteMode {
            
            guard let blueprint = containsBlueprint else {return}
            
            print("deleting!")
            
            blueprint.warningTexture?.removeFromParent()
            blueprint.crackTexture?.removeFromParent()
            blueprint.removeFromParent()
            let index = GameSceneCommunicator.instance.blueprints.firstIndex(of: blueprint)
            if index != nil {
                GameSceneCommunicator.instance.blueprints.remove(at: index!)
            }
            containsBlueprint = nil
            
            GameSceneCommunicator.instance.newFoundationTotalCost -= FoundationData.BASE_COST
            
            return
        }
        
        if containsBlueprint == nil && !containsFoundation {
            
            
            FoundationPlateFactory().createFoundationPlate(position: self.position, tile: self, isStartingFoundation: false)
            let foundationBlueprint = FoundationPlateNodes.foundationPlatesNode.children[FoundationPlateNodes.foundationPlatesNode.children.count-1] as! FoundationPlate
            foundationBlueprint.texture = SKTexture(imageNamed: "foundation_blueprint")
            foundationBlueprint.alpha = 0.5
            GameSceneCommunicator.instance.blueprints.append(foundationBlueprint)
            self.containsBlueprint = foundationBlueprint
            
            GameSceneCommunicator.instance.newFoundationTotalCost += FoundationData.BASE_COST
        }

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
