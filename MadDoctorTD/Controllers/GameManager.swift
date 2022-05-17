//
//  GameManager.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-03.
//

import Foundation

class GameManager: ObservableObject{
    
    static var instance = GameManager()
    
    //Variables
    @Published var isPaused: Bool = false
    @Published var currentMoney: Int = PlayerData.START_MONEY

    @Published var nextWaveCounter: Int = 0
    @Published var currentWave: Int = 0
    
    @Published var isMusicOn: Bool = true
    @Published var isSfxOn: Bool = true
    
    @Published var researchPoints: Int = PlayerData.START_RESEARCH_POINTS
    
    @Published var isGameOver: Bool = false
    @Published var baseHp: Int = PlayerData.BASE_HP
    
    @Published var rapidFireTowerUnlocked: Bool = false
    @Published var sniperTowerUnlocked: Bool = false
    @Published var cannonTowerUnlocked: Bool = false
    
    //SINGLETON
    private init(){}
    
    
    func getDamage(){
        
        baseHp -= 1
        if baseHp <= 0{
            isGameOver = true
        }
    }
    
    
}
