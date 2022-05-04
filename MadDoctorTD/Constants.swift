//
//  Constants.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-03.
//

import Foundation
import SpriteKit


enum AppState: Int{
    
    case startMenu = 0 , labMenu, gameScene, researchMenu, settingsMenu
    
}

enum GameState: Int{
    
    case menus = 0 , build, wave, pause
    
}

enum ActionState: Int{
    
    case none = 0, placeFoundation, placeTower, sellTower, upgradeTower 
    
}

struct PhysicsCategory{
    
    static let None: UInt32 = 0
    static let All: UInt32 = 0xFFFFFFFF
    static let Edge: UInt32 = 0b1
    static let Foundation: UInt32 = 0b10
    static let Enemy: UInt32 = 0b100
    
}

struct FoundationData{
    
    static let size: CGSize = CGSize(width: 32, height: 32)
    static let price: Int = 100
    
}


//Towers
enum TowerTypes: Int{
    case gunTower = 0
}

//Bullets


//Enemies

struct EnemiesData{
    
    static let size: CGSize = CGSize(width: 32, height: 32)
    static let baseHP: Int = 100
    static let baseSpeed: Float = 2.0
    
}

