//
//  Edge.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-05.
//

import Foundation
import SpriteKit

class Edge : SKSpriteNode{
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    init(){
        
        //Texture Init
        
        let size = DefaultTileData.size
            
        super.init(texture: nil, color: .clear, size: size)
        
        
    }
            
        
    
    
}
