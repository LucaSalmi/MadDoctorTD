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
    
    var levelButton: SKSpriteNode? = nil
    var settingsButton: SKSpriteNode? = nil
    var closeButton: SKSpriteNode? = nil
    
    var settingsMenu: SKSpriteNode? = nil
    var levelMenu: SKSpriteNode? = nil
    
    var startAnimationCount: Int = 60000
    var musicStarted: Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        SoundManager.playBGM(bgmString: SoundManager.DoorsTheme, bgmExtension: SoundManager.mp3Extension)
    }
    
    override func didMove(to view: SKView) {
        
        doorOne = self.childNode(withName: "DoorOne")
        doorTwo = self.childNode(withName: "DoorTwo")
        
        levelButton = self.childNode(withName: "LevelButton") as? SKSpriteNode
        settingsButton = self.childNode(withName: "LevelButton") as? SKSpriteNode
        
        settingsMenu = self.childNode(withName: "SettingsMenu") as? SKSpriteNode
        levelMenu = self.childNode(withName: "LevelMenu") as? SKSpriteNode
        
        closeButton = settingsMenu?.childNode(withName: "CloseSettingsButton") as? SKSpriteNode

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let touch = touches.first else {
            return
        }

        let location = touch.location(in: self)
        guard let node = nodes(at: location).first else {return}

        if node.name == "DoorButton"{
            // start menu scene
            print("Start Menu Scene")
            if startAnimationCount > 0 {
                startAnimationCount = 0
            }
        } else {
            SoundManager.playMetalTapSFX(scene: self)
            print("Play metal tap sound")
        }
        
        if node.name == "CloseSettingsButton"{
            print("SettingsMenu closed")
            hideExtraMenus()
        }
        
        if node.name == "CloseLevelButton"{
            print("LevelMenu closed")
            hideExtraMenus()
        }
        
        if node.name == "SettingsButton"{
            
            print("settingButton Pressed")
            showSettingsMenu()
        }
        
        if node.name == "LevelButton"{
            
            print("levelButton Pressed")
            showLevelMenu()
        }
        
    }
    
    func showSettingsMenu() {
        
        settingsMenu?.alpha = 1
        levelMenu?.alpha = 0
        
    }
    
    func showLevelMenu() {
        
        settingsMenu?.alpha = 0
        levelMenu?.alpha = 1
        
    }
    func hideExtraMenus() {
        
        settingsMenu?.alpha = 0
        levelMenu?.alpha = 0
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
       
        if !communicator.animateDoors{
            return
        }
        
        if startAnimationCount > 0 {
            startAnimationCount -= 1
            return
        }
        
        if !musicStarted {
            SoundManager.playBGM(bgmString: SoundManager.airlockDoorsTheme, bgmExtension: SoundManager.wavExtension)
            musicStarted = true
        }
        
        doorOne?.position.x -= 3.5
        doorTwo?.position.x += 3.5
        
        if doorOne!.position.x + doorOne!.frame.size.width/2 < -self.size.width/2{
            communicator.animateDoors = false
        }
       
        
    }
    

}
