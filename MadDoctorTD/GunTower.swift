//
//  GunTower.swift
//  MadDoctorTD
//
//  Created by Calle Höglund on 2022-05-04.
//

import Foundation
import SpriteKit
import SwiftUI

class GunTower: Tower{
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    override init(position: CGPoint){
        
        
        super.init(position: position)
        
        texture = SKTexture(imageNamed: "Sand_Grid_DownRightInterior")
    
    }
    
}
