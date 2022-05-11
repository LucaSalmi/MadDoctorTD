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
    @Published var showLab: Bool = false
    @Published var isPaused: Bool = false
    @Published var currentMoney: Int = 2500
    @Published var nextWaveCounter: Int = 0
    @Published var currentWave: Int = 0
    
    @Published var isMusicOn: Bool = true
    @Published var isSfxOn: Bool = true

    
    //SINGLETON
    private init(){}
    
}
