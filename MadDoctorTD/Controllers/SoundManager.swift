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

    //In game announcer

    static let announcer = "portal_located."

    //Research Room button SFX

    static let buttonOneSFX = "button_press_one."
    static let buttonTwoSFX = "button_press_two."
    static let buttonThreeSFX = "button_press_three."
    static let buttonFourSFX = "button_press_four."
    static let switchToResearchRoomSFX = "research_view_open."
    static let researchViewAtmosphere = "research_interface_atmosphere"
    
    static let upgradeUnlocked = "button_7."
    static let upgradePressed = "button_2."

    static let errorSound = "wrong_click_2"

    // Lose lfe SFX (for base)

    static let base_hp_loss_1 = "base_hp_loss_4."
    static let base_hp_loss_2 = "base_hp_loss_5."

    // Rapid Fire Turret SFX

    static let stoppedFiringSFX = "rapidStoppedFiringSFX."
    // Airlock SFX

    static let airlockSFX = "airlock_SFX."

    //Upgrade Turret SFX

    static let wrench_upgrade_1 = "wrench_upgrade_1."
    static let wrench_upgrade_2 = "wrench_upgrade_2."
    static let wrench_upgrade_3 = "wrench_upgrade_3."
    static let wrench_upgrade_4 = "wrench_upgrade_4."
    static let wrench_upgrade_5 = "wrench_upgrade_5."
    static let wrench_upgrade_6 = "wrench_upgrade_6."
    static let wrench_upgrade_7 = "wrench_upgrade_7."
    static let wrench_upgrade_8 = "wrench_upgrade_8."

    static let wrench_upgradeSounds = [wrench_upgrade_1, wrench_upgrade_2, wrench_upgrade_3, wrench_upgrade_4, wrench_upgrade_5, wrench_upgrade_6, wrench_upgrade_7, wrench_upgrade_8]

    static let upgrade_1 = "upg_sound_1."
    static let upgrade_2 = "upg_sound_2."
    static let upgrade_3 = "upg_sound_3."
    static let upgrade_4 = "upg_sound_4."
    static let upgrade_5 = "upg_sound_5."

    static let upgradeSounds = [upgrade_1, upgrade_2, upgrade_3, upgrade_4, upgrade_5]

    static let buttonSFX_one = "button_7."
    static let buttonSFX_two = "button_2."
    static let buttonSFX_three = "button_8."

    //DeathSounds

    static let slimeDeathSFX = "slime_death4"

    // Boss Giant Step SFX

    //static let giant_steps_1 = "giant_step_1."
    //static let giant_steps_2 = "giant_step_2."
    //static let giant_steps_3 = "giant_step_3."
    //static let giant_steps_4 = "giant_step_4."

    //AtmosphereSound

    static let desertAmbience = "desert_custom_atmosphere"
    static let ambienceOne = "atmosphere_bg_1"
    static let ambienceTwo = "atmosphere_bg_2"
    
    //BGMusic

    static let MainThemeBackgroundMusic = "mad_td_theme"
    static let filteredMainThemeBackgroundMusic = "filtered_theme_song_no_fizz"
    static let airlockDoorsTheme = "mad_td_airlock_theme"
    static let DoorsTheme = "3_MAD_TD_Theme_Party_In_The_Basement_Deep"
    static let simplifiedTheme = "mad_td_simplified"
    static let mainMenuTheme = "mad_td_menu_theme"
    
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

//    static func playRapidFireShotsSFX() {
//
//        let rand = Int.random(in:1...3)
//        let rapidFireShot = "gunShot_\(rand)."
//
//        playSFX(sfxName: rapidFireShot, scene: GameScene.instance!, sfxExtension: mp3Extension)
//
//    }

    static func playMetalTapSFX(scene: SKScene) {

        let rand = Int.random(in:1...4)
        let metalTap = "metal_tap_\(rand)."

        playSFX(sfxName: metalTap, scene: scene, sfxExtension: mp3Extension)

    }

    static func playGiantStepSFX(scene: SKScene) {

        let rand = Int.random(in:1...4)
        let giantStep = "giant_step_\(rand)."

        playSFX(sfxName: giantStep, scene: scene, sfxExtension: mp3Extension)

    }

    static func playMortarSwooshSFX() {

        let rand = Int.random(in:1...7)
        let mortarSwoosh = "mortar_swoosh\(rand)."

        playSFX(sfxName: mortarSwoosh, scene: GameScene.instance!, sfxExtension: SoundManager.mp3Extension)

    }

    static func playCannonFireSFX() {

        let rand = Int.random(in:1...3)
        let cannonFireSFX = "cannon_fire_\(rand)."

        playSFX(sfxName: cannonFireSFX, scene: GameScene.instance!, sfxExtension: SoundManager.mp3Extension)
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
