//
//  GameManager.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-03.
//

import Foundation
import SpriteKit

class GameManager: ObservableObject{
    
    static var instance = GameManager()
    
    //Variables
    @Published var isPaused: Bool = false
    @Published var currentMoney: Int = PlayerData.START_MONEY
    
    @Published var slimeMaterials: Int = 1
    @Published var squidMaterials: Int = 0
    
    @Published var nextWaveCounter: Int = 0
    @Published var currentWave: Int = 1
    
    @Published var isMusicOn: Bool = true
    @Published var isSfxOn: Bool = true
    
    @Published var researchPoints: Int = PlayerData.START_RESEARCH_POINTS
    
    @Published var isGameOver: Bool = false
    @Published var baseHp: Int = PlayerData.BASE_HP
    @Published var baseHPLost: Int = 0
    
    //Rapid Fire Tower Unlocks
    @Published var rapidFireTowerUnlocked: Bool = false
    @Published var rapidFireTowerDamageUnlocked: Bool = false
    @Published var rapidFireTowerSpeedUnlocked: Bool = false
    @Published var rapidFireTowerRangeUnlocked: Bool = false
    @Published var slowProjectilesUnlocked: Bool = false
    
    //Sniper Tower Unlocks
    @Published var sniperTowerUnlocked: Bool = false
    @Published var sniperTowerDamageUnlocked: Bool = false
    @Published var sniperTowerSpeedUnlocked: Bool = false
    @Published var sniperTowerRangeUnlocked: Bool = false
    @Published var poisonProjectilesUnlocked: Bool = false
    
    //Cannon Tower Unlocks
    @Published var cannonTowerUnlocked: Bool = false
    @Published var cannonTowerDamageUnlocked: Bool = false
    @Published var cannonTowerSpeedUnlocked: Bool = false
    @Published var cannonTowerRangeUnlocked: Bool = false
    @Published var mineProjectilesUnlocked: Bool = false
    
    //Gun Tower Unlocks
    @Published var gunTowerUnlocked: Bool = true
    @Published var gunTowerDamageUnlocked: Bool = false
    @Published var gunTowerSpeedUnlocked: Bool = false
    @Published var gunTowerRangeUnlocked: Bool = false
    @Published var bouncingProjectilesUnlocked: Bool = false
    
    @Published var currentLevel = 2
    
    //SINGLETON
    private init(){}
    
    
    func getDamage(incomingDamage: Int){
        GameScene.instance!.showDamageIndicator = true
        baseHp -= incomingDamage
        baseHPLost += 1 
        if baseHp <= 0{
            isGameOver = true
            SoundManager.playSFX(sfxName: SoundManager.base_hp_loss_2, scene: GameScene.instance!, sfxExtension: SoundManager.mp3Extension)
        }
    }
    
    func displayDamageIndicator(){
        
        let dmgIndicator = GameScene.instance!.damageIndicator
        
        dmgIndicator?.alpha += 0.05
        
        if dmgIndicator!.alpha > 0.4{
            
            dmgIndicator?.alpha = 0
            GameScene.instance!.showDamageIndicator = false
        }
        
    }
    
    
}
