//
//  ClickableTile.swift
//  MadDoctorTD
//
//  Created by Daniel Falkedal on 2022-05-03.
//

import Foundation
import SpriteKit

class ClickableTile: SKSpriteNode{
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    init(position: CGPoint){
        
        super.init(texture: nil, color: .clear, size: CGSize(width: 32, height: 32))
        
        self.position = position
        
    }
    
    func onClick() {
        print("Tile clicked at position: \(position)")
        
        let communicator = GameSceneCommunicator.instance
        communicator.currentTile = self
        communicator.showFoundationMenu = true
    }
    
}
