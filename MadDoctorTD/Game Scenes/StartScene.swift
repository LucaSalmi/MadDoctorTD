//
//  StartScene.swift
//  MadDoctorTD
//
//  Created by Calle Höglund on 2022-05-11.
//

import Foundation
import SpriteKit

class StartScene: SKScene{
    
    let appManager = AppManager.appManager
    let communicator = StartSceneCommunicator.instance
    
    var doorOne: SKNode? = nil
    var doorTwo: SKNode? = nil
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMove(to view: SKView) {
        
        doorOne = self.childNode(withName: "DoorOne")
        doorTwo = self.childNode(withName: "DoorTwo")

        print("GAME STARTED")
        SoundManager.playBGMsfxExtension(bgmString: SoundManager.airlockDoorsTheme)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
       
        if !communicator.animateDoors{
            return
        }
        
        doorOne?.position.x -= 5
        doorTwo?.position.x += 5
        
        if doorOne!.position.x + doorOne!.frame.size.width/2 < -self.size.width/2{
            communicator.animateDoors = false
        }
       
        
    }
    
    
    
    
    
}
