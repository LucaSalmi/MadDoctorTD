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
    @Published var moneyEarned: Int = 0
    @Published var survivalBonusNumber: Int = 0
    @Published var slimeMaterialGained: Int = 0
    @Published var squidMaterialGained: Int = 0
    
    @Published var slimeMaterials: Int = 0
    @Published var squidMaterials: Int = 0
    
    @Published var nextWaveCounter: Int = 0
    @Published var currentWave: Int = 1
    
    @Published var isMusicOn: Bool = true
    @Published var isSfxOn: Bool = true
    
    @Published var researchPoints: Int = PlayerData.START_RESEARCH_POINTS
    
    @Published var isGameOver: Bool = false
    @Published var baseHp: Int = PlayerData.BASE_HP
    @Published var baseHPLost: Int = 0
    
    @Published var currentLevel = 2
    
    //SINGLETON
    private init(){}
    
    
    func getDamage(incomingDamage: Int){
        GameScene.instance!.uiManager!.showDamageIndicator = true
        baseHp -= incomingDamage
        baseHPLost += 1 
        if baseHp <= 0{
            isGameOver = true
            SoundManager.playSFX(sfxName: SoundManager.base_hp_loss_2, scene: GameScene.instance!, sfxExtension: SoundManager.mp3Extension)
        }
    }
    
    func displayDamageIndicator(){
        
        let dmgIndicator = GameScene.instance!.uiManager!.damageIndicator
        
        dmgIndicator?.alpha += 0.05
        
        if dmgIndicator!.alpha > 0.4{
            
            dmgIndicator?.alpha = 0
            GameScene.instance!.uiManager!.showDamageIndicator = false
        }
        
    }
    
    func resetAllSkills() {
        
        LabSceneCommunicator.instance.gunTowerResearchLevel.removeAll()
        LabSceneCommunicator.instance.gunTowerResearchLevel.append("1")
        LabSceneCommunicator.instance.rapidTowerResearchLevel.removeAll()
        LabSceneCommunicator.instance.cannonTowerResearchLevel.removeAll()
        LabSceneCommunicator.instance.sniperTowerResearchLevel.removeAll()
        
    }
    
    
}
