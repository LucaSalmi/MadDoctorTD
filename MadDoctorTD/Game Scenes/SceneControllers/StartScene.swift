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
    
    var settingsMenu: SKSpriteNode? = nil
    var levelMenu: SKSpriteNode? = nil
    
    var startAnimationCount: Int = 60000
    var musicStarted: Bool = false
    
    let fadeIn = SKAction.fadeAlpha(to: 1, duration: 1)
    let fadeOut = SKAction.fadeAlpha(to: 0, duration: 1)
    
    var enableMetalTapSound = true
    
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
            if enableMetalTapSound{
                SoundManager.playMetalTapSFX(scene: self)
                print("Play metal tap sound")
            }
            
        }
        
        
        
        if node.name == "CloseSettingsButton"{
            print("SettingsMenu closed")
            hideExtraMenus()
        }
        
        if node.name == "LevelOneButton"{
            
            print("level 1 pressed")
            
            GameManager.instance.currentLevel = 1
            
            if GameScene.instance != nil{
                
                GameManager.instance.isGameOver = true
                GameManager.instance.isPaused = false
                GameScene.instance!.resetGameScene()
                
            }
            
            appManager.state = .gameScene
            SoundManager.playBGM(bgmString: SoundManager.ambienceOne, bgmExtension: SoundManager.mp3Extension)
            return
            
            
        }
        if node.name == "LevelTwoButton"{
            
            print("level 2 pressed")
            
            GameManager.instance.currentLevel = 2
            
            
            if GameScene.instance != nil{
                
                GameManager.instance.isGameOver = true
                GameManager.instance.isPaused = false
                GameScene.instance!.resetGameScene()
                
            }
            
            appManager.state = .gameScene
            SoundManager.playBGM(bgmString: SoundManager.ambienceOne, bgmExtension: SoundManager.mp3Extension)
            return
            
            
        }
        
        if node.name == "CloseLevelButton"{
            print("LevelMenu closed")
            hideExtraMenus()
            return
        }
        
        if node.name == "SettingsButton" && levelMenu?.alpha == 0{
            
            print("settingButton Pressed")
            showSettingsMenu()
        }
        
        if node.name == "musicCheckY" || node.name == "musicCheckX"{
            musicSwitch()
            return
        }
        
        if node.name == "sfxCheckY" || node.name == "sfxCheckX"{
            sfxSwitch()
            return
        }
        
        if node.name == "LevelButton" && settingsMenu?.alpha == 0{
            
            print("levelButton Pressed")
            showLevelMenu()
        }
        
        if node.name == "creditsButton"{
            
            AppManager.appManager.state = .creditsScene
        }
        
    }
    
    func musicSwitch(){
    
        guard let musicOn = settingsMenu?.childNode(withName: "musicCheckY") else {return}
        guard let musicOff = settingsMenu?.childNode(withName: "musicCheckX") else {return}
        
        if musicOn.alpha > 0{
            
            musicOn.alpha = 0
            musicOff.alpha = 1
            GameManager.instance.isMusicOn = false
            SoundManager.stopMusic()
            
        }else{
            
            musicOn.alpha = 1
            musicOff.alpha = 0
            GameManager.instance.isMusicOn = true
            SoundManager.playBGM(bgmString: SoundManager.mainMenuTheme, bgmExtension: SoundManager.mp3Extension)
        }
        
    }
    
    func sfxSwitch(){
        
        guard let sfxOn = settingsMenu?.childNode(withName: "sfxCheckY") else {return}
        guard let sfxOff = settingsMenu?.childNode(withName: "sfxCheckX") else {return}
        
        if sfxOn.alpha > 0{
            
            sfxOn.alpha = 0
            sfxOff.alpha = 1
            GameManager.instance.isSfxOn = false
            
        }else{
            
            sfxOn.alpha = 1
            sfxOff.alpha = 0
            GameManager.instance.isSfxOn = true
            
        }
        
    }
    
    func showSettingsMenu() {
  
        settingsMenu?.run(fadeIn)
        levelMenu?.run(fadeOut)
//        settingsMenu?.alpha = 1
//        levelMenu?.alpha = 0
        
    }
    
    func showLevelMenu() {
        
        settingsMenu?.run(fadeOut)
        levelMenu?.run(fadeIn)
//        settingsMenu?.alpha = 0
//        levelMenu?.alpha = 1
        
    }
    func hideExtraMenus() {
        
        settingsMenu?.run(fadeOut)
        levelMenu?.run(fadeOut)
//        settingsMenu?.alpha = 0
//        levelMenu?.alpha = 0
        
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
            //SoundManager.playBGM(bgmString: SoundManager.airlockDoorsTheme, bgmExtension: SoundManager.wavExtension)
            SoundManager.playBGM(bgmString: SoundManager.mainMenuTheme, bgmExtension: SoundManager.mp3Extension)
            SoundManager.playSFX(sfxName: SoundManager.airlockSFX, scene: self, sfxExtension: SoundManager.mp3Extension)
            musicStarted = true
        }
        
        doorOne?.position.x -= 3.5
        doorTwo?.position.x += 3.5
        
        if doorOne!.position.x + doorOne!.frame.size.width/2 < -self.size.width/2{
            communicator.animateDoors = false
            enableMetalTapSound = false
            self.childNode(withName: "DoorButton")?.alpha = 0
        }
        
        
    }
    
    
}
