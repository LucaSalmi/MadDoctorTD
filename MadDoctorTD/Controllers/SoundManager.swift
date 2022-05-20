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

    static let wavExtension = ".wav" // with . (dot)
    static let mp3Extension = "mp3" // without . (dot)
    
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

    //Upgrade Turret SFX

    static let upgrade_1 = "upg_sound_1."
    static let upgrade_2 = "upg_sound_2."
    static let upgrade_3 = "upg_sound_3."
    static let upgrade_4 = "upg_sound_4."
    static let upgrade_5 = "upg_sound_5."

    static let upgradeSounds = [upgrade_1, upgrade_2, upgrade_3, upgrade_4, upgrade_5]

//    let rangeUpgradeCount = Tower().rangeUpgradeCount
//    let fireRateUpgradeCount = Tower()?.rangeUpgradeCount
//    let damageUpgradeCount = Tower()?.damageUpgradeCount

    //DeathSounds

    static let slimeDeathSFX = "slime_death4"

    //AtmosphereSound

    static let desertAmbience = "desert_custom_atmosphere"
    
    //BGMusic


    static let MainThemeBackgroundMusic = "mad_td_theme"
    static let filteredMainThemeBackgroundMusic = "filtered_theme_song_no_fizz"
    static let airlockDoorsTheme = "mad_td_airlock_theme"
    static let DoorsTheme = "3_MAD_TD_Theme_Party_In_The_Basement_Deep"
    static let simplifiedTheme = "mad_td_simplified"
    
    static var musicPlayer: AVAudioPlayer!

    static func playSFX(sfxName: String, scene: SKScene, sfxExtension: String = SoundManager.wavExtension) {
        
        let gameManager = GameManager.instance
        if !gameManager.isSfxOn{
            return
        }
        let sfx = sfxName + sfxExtension
        let sfxAction = SKAction.playSoundFileNamed(sfx, waitForCompletion: false)
        scene.run(sfxAction)
        
    }

    static func playSniperSFX() {

        let rand = Int.random(in:1...5)
        let sniperSound = "sniper_bullet_fly_by_\(rand)"
        
        playSFX(sfxName: sniperSound, scene: GameScene.instance!)

    }

    static func playMetalTapSFX(scene: StartScene) {

        let rand = Int.random(in:1...4)
        let metalTap = "metal_tap_\(rand)."

        playSFX(sfxName: metalTap, scene: scene, sfxExtension: mp3Extension)

    }

    static func playMortarSwooshSFX() {

        let rand = Int.random(in:1...7)
        let mortarSwoosh = "mortar_swoosh\(rand)."

        playSFX(sfxName: mortarSwoosh, scene: GameScene.instance!, sfxExtension: SoundManager.mp3Extension)

    }
    
    static func playBGM(bgmString: String, bgmExtension: String) {
        
        musicPlayer?.stop()
        
        if !GameManager.instance.isMusicOn {
            return
        }
        
        let bgm = Bundle.main.path(forResource: bgmString, ofType: bgmExtension)
        
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
