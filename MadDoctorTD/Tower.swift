//
//  Tower.swift
//  MadDoctorTD
//
//  Created by Calle Höglund on 2022-05-04.
//

import Foundation
import SpriteKit


class Tower: SKSpriteNode{
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    init(position: CGPoint){
        
        let texture: SKTexture = SKTexture(imageNamed: "Sand_Grid_DownRightInterior")
        super.init(texture: texture, color: .clear, size: FoundationData.size)
        
        name = "Tower"
        self.position = position
        zPosition = 2
    
    }

    
    
}
