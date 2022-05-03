//
//  GameScene.swift
//  MadDoctorTD
//
//  Created by Daniel Falkedal on 2022-05-03.
//

import Foundation
import GameplayKit
import SpriteKit
import SwiftUI

class GameScene: SKScene {
    
    static var instance: GameScene? = nil
    
    var clickableTilesNode: SKNode = SKNode()
    var foundationPlatesNode: SKNode = SKNode()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMove(to view: SKView) {
        
        GameScene.instance = self
        
        setupClickableTiles()
        setupStartFoundation()
        
    }
    
    private func setupClickableTiles() {
        
        guard let clickableTileMap = childNode(withName: "clickable_tiles")as? SKTileMapNode else {
            return
        }
        
        for row in 0..<clickableTileMap.numberOfRows{
            for column in 0..<clickableTileMap.numberOfColumns{
                
                guard let tile = tile(in: clickableTileMap, at: (column, row)) else {continue}
                guard tile.userData?.object(forKey: "isClickableTile") != nil else {continue}
                
                
                
                let clickableTile = ClickableTile(position: clickableTileMap.centerOfTile(atColumn: column, row: row))
                
                clickableTilesNode.addChild(clickableTile)
                
        
                
                
            }
        }
        
        clickableTilesNode.name = "ClickableTiles"
        addChild(clickableTilesNode)
        clickableTileMap.removeFromParent()
        
    }
    
    private func setupStartFoundation() {
        
        let clickableTile1 = clickableTilesNode.children[55] as! ClickableTile
        clickableTile1.containsFoundation = true
        
        let foundationPlate1 = FoundationPlate(position: clickableTile1.position)
        foundationPlatesNode.addChild(foundationPlate1)
        
        addChild(foundationPlatesNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                if node is ClickableTile {
                    let clickableTile = node as! ClickableTile
                    clickableTile.onClick()
                }
                if node is FoundationPlate {
                    print("Foundation Plate clicked")
                }
            }
        }
        
    }
    
    func tile(in tileMap: SKTileMapNode, at coordinates: tileCoordinates) -> SKTileDefinition?{
        return tileMap.tileDefinition(atColumn: coordinates.column, row: coordinates.row)
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        //Update code
        
    }
    
}

typealias tileCoordinates = (column: Int, row: Int)
