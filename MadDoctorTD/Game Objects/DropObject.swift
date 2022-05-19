//
//  DropObject.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-19.
//

import Foundation
import SpriteKit

class DropObject: PriceObject{
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    init(startPoint: CGPoint, targetPoint: CGPoint, bossTexture: SKTexture){
        
        super.init(startPosition: startPoint, targetPoint: targetPoint)
        self.texture = bossTexture
        self.size.width /= 2
        self.size.height /= 2
        
    }
    
    
}
