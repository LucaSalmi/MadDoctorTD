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
    
    @Published var slimeMaterials: Int = 0
    @Published var squidMaterials: Int = 0
    
    @Published var nextWaveCounter: Int = 0
    @Published var currentWave: Int = 1
    
    @Published var isMusicOn: Bool = true
    @Published var isSfxOn: Bool = true
    
    @Published var researchPoints: Int = PlayerData.START_RESEARCH_POINTS
    
    @Published var isGameOver: Bool = false
    @Published var baseHp: Int = PlayerData.BASE_HP
    
    @Published var rapidFireTowerUnlocked: Bool = false
    @Published var sniperTowerUnlocked: Bool = false
    @Published var cannonTowerUnlocked: Bool = false
    
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
