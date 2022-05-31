//
//  Money.swift
//  MadDoctorTD
//
//  Created by Daniel Falkedal on 2022-05-19.
//

import Foundation
import SpriteKit

class MoneyObject: SKSpriteNode {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    init(startPosition: CGPoint) {
        
        let size = CGSize(width: FoundationData.SIZE.width/6, height: FoundationData.SIZE.height/6)
        
        super.init(texture: SKTexture(imageNamed: "money_object"), color: .clear, size: size)
        self.position = startPosition
        self.zPosition = 5
    }
    
    func onDestroy() {
        self.removeFromParent()
    }
    
    func update() {
        
        self.size.width += 1.5
        self.size.height += 1.5
        
        self.alpha -= 0.04
        
        if self.alpha <= 0 {
            onDestroy()
        }
        
    }
    
}
