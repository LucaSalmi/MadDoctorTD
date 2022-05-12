//
//  SoundManager.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-03.
//

import Foundation
import GameplayKit
import AVFAudio

class SoundManager {

    static let sfxExtension = ".wav" // with . (dot)
    static let bgmExtension = "mp3" // without . (dot)
    
    //Tracks name: String
    
    static let gunProjectileImpactSFX = "gun_projectile_impact"
    static let sniperProjectileImpactSFX = "AWP_SOUND_EFFECT"
    static let buildingPlacementSFX = "construction_sound_effect"
    static let foundationPlacementSFX = "finger_tap_boosted"
    static let cannonShotFiredSFX = "cannon_shot_fired."
    static let cannonTowerImpactSFX = "cannon_tower_impact."

    //Research Room button SFX

    static let buttonOneSFX = "button_press_one."
    static let buttonTwoSFX = "button_press_two."
    static let buttonThreeSFX = "button_press_three."
    static let buttonFourSFX = "button_press_four."

    static let switchToResearchRoomSFX = "research_view_open."

    static let researchViewAtmosphere = "research_interface_atmosphere"

    //DeathSounds

    static let slimeDeathSFX = "slime_death4"

    //AtmosphereSound

    static let desertAmbience = "desert_custom_atmosphere"
    
    //BGMusic

    static let MainThemeBackgroundMusic = "mad_td_theme"
    static let filteredMainThemeBackgroundMusic = "filtered_theme_song_no_fizz"
    static let airlockDoorsTheme = "mad_td_airlock_theme"
    
    static var musicPlayer: AVAudioPlayer!

    static func playSFX(sfxName: String, sfxExtension: String = SoundManager.sfxExtension) {
        
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

        playSFX(sfxName: mortarSwoosh, sfxExtension: SoundManager.bgmExtension)

    }
    
    static func playBGM(bgmString: String) {
        
        musicPlayer?.stop()
        
        if !GameManager.instance.isMusicOn {
            return
        }
        
        let bgm = Bundle.main.path(forResource: bgmString, ofType: SoundManager.bgmExtension)
        
        do {
            let url = URL(fileURLWithPath: bgm!)
            musicPlayer = try AVAudioPlayer(contentsOf: url)
            
        } catch {
            
        }
        musicPlayer!.play()
        musicPlayer!.numberOfLoops = -1
    }

    static func playBGMsfxExtension(bgmString: String) {

        musicPlayer?.stop()

        if !GameManager.instance.isMusicOn {
            return
        }

        let bgm = Bundle.main.path(forResource: bgmString, ofType: SoundManager.sfxExtension)

        do {
            let url = URL(fileURLWithPath: bgm!)
            musicPlayer = try AVAudioPlayer(contentsOf: url)

        } catch {

        }
        musicPlayer!.play()
        musicPlayer!.numberOfLoops = -1
    }
    
    static func stopMusic(){
        
        musicPlayer?.stop()
        
    }
}
