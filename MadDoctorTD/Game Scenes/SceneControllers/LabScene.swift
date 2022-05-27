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
    
    let communicator = LabSceneCommunicator.instance
    
    var fadeInScene: Bool = false
    var fadeOutScene: Bool = false
    
    var transitionAmount: Double = 0.02
    
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
        
        AppManager.appManager.transitionOpacity = 1
        fadeInScene = true
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if fadeInScene {
            AppManager.appManager.transitionOpacity -= transitionAmount
            if AppManager.appManager.transitionOpacity <= 0 {
                fadeInScene = false
            }
        }
        
        if fadeOutScene {
            
            AppManager.appManager.transitionOpacity += transitionAmount
            
            if AppManager.appManager.transitionOpacity >= 1 {
                fadeOutScene = false
                AppManager.appManager.transitionOpacity = 0
                AppManager.appManager.state = .gameScene
                SoundManager.playBGM(bgmString: SoundManager.ambienceOne, bgmExtension: SoundManager.mp3Extension)
            }
            
        }
        
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
