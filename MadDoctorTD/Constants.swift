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
    static let Projectile: UInt32 = 0b1000
    
}

struct DefaultTileData {
    static let size: CGSize = CGSize(width: 86, height: 86)
}

struct FoundationData{
    
    static let size: CGSize = DefaultTileData.size
    static let price: Int = 100
    
}


//Towers
enum TowerTypes: Int{
    case gunTower = 0
}

struct TowerData {
    
    static let size: CGSize = CGSize(width: DefaultTileData.size.width*2, height: DefaultTileData.size.height*2)
    static let ATTACK_RANGE: CGFloat = CGFloat(DefaultTileData.size.width * 3)
    static let FIRE_RATE: Int = 20
    static let ATTACK_DAMAGE: Int = 10
    
}

//Bullets
enum ProjectileTypes: Int {
    case gunProjectile = 0
}

struct ProjectileData {
    static let size: CGSize = CGSize(width: DefaultTileData.size.width * 0.5, height: DefaultTileData.size.height * 0.5)
    static let speed: CGFloat = CGFloat(8.0)
}

//Enemies

struct EnemiesData{
    
    static let size: CGSize = CGSize(width: 43, height: 43)
    static let baseHP: Int = 100
    static let baseSpeed: CGFloat = 50
    
}

