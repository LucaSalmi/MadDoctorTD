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
    
    var fadeInToast: Bool = false
    var fadeOutToast: Bool = false
    
    let toastFadeAmount: Double = 0.06
    let toastSpeed: Double = 6
    let toastMaxOpacity: Double = 8.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMove(to view: SKView) {
        
        if LabScene.instance != nil {
            return
        }
        
        LabScene.instance = self
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        let communicator = LabSceneCommunicator.instance
        
        if fadeInToast {
            
            communicator.toastOpacity += toastFadeAmount
            
            if communicator.toastPositionY >= communicator.defaultToastPositionY {
                communicator.toastPositionY -= toastSpeed
            }
            
            if communicator.toastOpacity >= toastMaxOpacity {
                fadeInToast = false
                communicator.toastOpacity = 1.0
                fadeOutToast = true
            }
            
        }
        
        if fadeOutToast {
            
            communicator.toastOpacity -= toastFadeAmount
            
            communicator.toastPositionY += toastSpeed
            
            if communicator.toastPositionY >= UIScreen.main.bounds.height {
                fadeOutToast = false
                communicator.toastOpacity = 0.0
            }
            
        }
        
    }
    
}
