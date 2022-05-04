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
        
        if containsFoundation {
            return
            
        }
        let communicator = GameSceneCommunicator.instance
        communicator.cancelAllMenus()
        
        let gameScene = GameScene.instance!
        
        var adjecentFound = false
        
        var leftPosition = position
        leftPosition.x -= 32
        var rightPosition = position
        rightPosition.x += 32
        var topPosition = position
        topPosition.y += 32
        var bottomPosition = position
        bottomPosition.y -= 32
        
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
        
        communicator.currentTile = self
        communicator.showFoundationMenu = true
    }
    
}
