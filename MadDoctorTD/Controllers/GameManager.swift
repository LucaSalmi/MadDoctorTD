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
    
    //Rapid Fire Tower Unlocks
    @Published var rapidFireTowerUnlocked: Bool = false
    
    //Sniper Tower Unlocks
    @Published var sniperTowerUnlocked: Bool = false
    
    //Cannon Tower Unlocks
    @Published var cannonTowerUnlocked: Bool = false
    
    //Gun Tower Unlocks
    @Published var gunTowerDamageUnlocked: Bool = false
    @Published var gunTowerSpeedUnlocked: Bool = false
    @Published var gunTowerRangeUnlocked: Bool = false
    @Published var bouncingProjectilesUnlocked: Bool = false
    
    @Published var currentLevel = 1
    
    //SINGLETON
    private init(){}
    
    
    func getDamage(incomingDamage: Int){
        GameScene.instance!.showDamageIndicator = true
        baseHp -= incomingDamage
        if baseHp <= 0{
            isGameOver = true
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
