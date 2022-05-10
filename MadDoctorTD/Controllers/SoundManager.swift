//
//  SoundManager.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-03.
//

import Foundation
import GameplayKit
import AVFAudio

class SoundManager{
    
    static let sfxExtension = ".wav" // with . (dot)
    static let bgmExtension = "mp3" // without . (dot)
    
    //Tracks name: String
    static let gunProjectileImpactSFX = "gun_projectile_impact"
    static let sniperProjectileImpactSFX = "AWP_SOUND_EFFECT"
    
    static var musicPlayer: AVAudioPlayer?

    
    static func playSFX(sfxName: String){
        
        guard let gameScene = GameScene.instance else { return }
        
        let sfx = sfxName + sfxExtension
        let sfxAction = SKAction.playSoundFileNamed(sfx, waitForCompletion: false)
        gameScene.run(sfxAction)
        
    }
    
    static func playBGM(bgmName: String){
        
        //TODO
        
    }
    
    static func stopMusic(){
        
        //TODO
        
    }
}
