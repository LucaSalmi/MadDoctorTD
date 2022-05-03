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
        
        if GameSceneCommunicator.instance.showFoundationMenu || containsFoundation {
            return
        }
        
        print("Tile clicked at position: \(position)")
        
        let gameScene = GameScene.instance!
        
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
    
}
