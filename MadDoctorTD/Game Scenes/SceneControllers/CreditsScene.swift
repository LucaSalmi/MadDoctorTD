//
//  CreditsScene.swift
//  MadDoctorTD
//
//  Created by Calle Höglund on 2022-05-24.
//

import Foundation
import SpriteKit

class CreditsScene: SKScene{
    
    var container: SKSpriteNode?
    
    var hampus: SKSpriteNode?
    var daniel: SKSpriteNode?
    var luca: SKSpriteNode?
    var calle: SKSpriteNode?
    var andreas: SKSpriteNode?
    
    var creators = [SKSpriteNode]()
    
    var thanksToButton: SKLabelNode?
    
    var tick: Int = 0
    var showCreators = false
    
    var creatorsAlphaIncrease = false
    
    var delay: Double = 0
    var delayIncrease: Double = 1
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMove(to view: SKView) {
        
        thanksToButton = self.childNode(withName: "ThanksToButton") as? SKLabelNode
        container = self.childNode(withName: "Container") as? SKSpriteNode
        
        hampus = container?.childNode(withName: "Hampus") as? SKSpriteNode
        daniel = container?.childNode(withName: "Daniel") as? SKSpriteNode
        luca = container?.childNode(withName: "Luca") as? SKSpriteNode
        calle = container?.childNode(withName: "Calle") as? SKSpriteNode
        andreas = container?.childNode(withName: "Andreas") as? SKSpriteNode
        
        creators.append(hampus!)
        creators.append(daniel!)
        creators.append(luca!)
        creators.append(calle!)
        creators.append(andreas!)
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {return}
        
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        for node in touchedNodes {
            if node.name == "ThanksToButton"{
                
                
                thanksToButton?.alpha = 0
                showCreators = true
                var soundID = 0
                
                for creator in creators {
                    
                    
                    delay += delayIncrease
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        
                        creator.alpha = 1
                        soundID += 1
                        SoundManager.playSFX(sfxName: "upg_sound_\(soundID).", scene: self, sfxExtension: SoundManager.mp3Extension)
                    }
                    
                }
                
                
            }
            
            if node.name == "Home"{
                self.removeAllChildren()
                AppManager.appManager.state = .startMenu
            }
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if thanksToButton!.alpha != 0 {
            
            let increaseAmount = 0.02
            let maxAlpha = 0.8
            
            if creatorsAlphaIncrease {
                thanksToButton!.alpha += increaseAmount
                if thanksToButton!.alpha >= maxAlpha {
                    thanksToButton!.alpha = maxAlpha - increaseAmount
                    creatorsAlphaIncrease = false
                }
            }
            else {
                thanksToButton!.alpha -= increaseAmount
                if thanksToButton!.alpha <= increaseAmount {
                    thanksToButton!.alpha = increaseAmount*2
                    creatorsAlphaIncrease = true
                }
            }
        }
        
        
        
        
        
        
        
    }
    
    
    
}
