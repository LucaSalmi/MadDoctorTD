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
    static let buildingPlacementSFX = "construction_sound_effect"
    static let foundationPlacementSFX = "finger_tap_boosted"

    //BGMusic

    static let MainThemeBackgroundMusic = "mad_td_theme"
    static let filteredMainThemeBackgroundMusic = "filtered_theme_song_no_fizz."
    
    static var musicPlayer: AVAudioPlayer!

    static func playSFX(sfxName: String){
        
        guard let gameScene = GameScene.instance else { return }
        let gameManager = GameManager.instance
        if !gameManager.isSfxOn{
            return
        }
        let sfx = sfxName + sfxExtension
        let sfxAction = SKAction.playSoundFileNamed(sfx, waitForCompletion: false)
        gameScene.run(sfxAction)
        
    }

    static func playSniperSFX() {

        let rand = Int.random(in:1...5)
        let sniperSound = "sniper_bullet_fly_by_\(rand)"
        
        playSFX(sfxName: sniperSound)

    }

    static func playMortarSwooshSFX() {

        let rand = Int.random(in:1...7)
        let mortarSwoosh = "mortar_swoosh\(rand)."

        playBGM(bgmName: mortarSwoosh)

    }
    
    static func playBGM(bgmName: String){

        guard let gameScene = GameScene.instance else { return }
        let gameManager = GameManager.instance
        if !gameManager.isSfxOn{
            return
        }

        let sfx = bgmName + bgmExtension
        let sfxAction = SKAction.playSoundFileNamed(sfx, waitForCompletion: false)
        gameScene.run(sfxAction)
        
    }

    static func playBackgroundMusic() {

        let url = Bundle.main.url(forResource: "filtered_theme_song_no_fizz", withExtension: "mp3")

        guard url != nil else {
            return
        }

        do {
            musicPlayer = try AVAudioPlayer(contentsOf: url!)
            musicPlayer.numberOfLoops = -1
            musicPlayer?.play()
        } catch {
            print("error playing Music")
        }
    }
    
    static func stopMusic(){
        
        //TODO
        
    }
}
