//
//  LabScene.swift
//  MadDoctorTD
//
//  Created by Daniel Falkedal on 2022-05-03.
//

import Foundation
import SpriteKit

class LabScene: SKScene {
    
    static var instance: LabScene?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMove(to view: SKView) {
        
        if LabScene.instance != nil {
            return
        }
        
        LabScene.instance = self
        
    }
    
}
