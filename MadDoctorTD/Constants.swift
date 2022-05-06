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
enum UpgradeTypes: Int{
    case damage = 0, range, firerate
}

enum EnemyTypes: Int{
    
    case standard = 0, fast, heavy, flying
    
}


//Towers
enum TowerTypes: Int{
    case gunTower = 0
}

struct TowerData {
    
    static let TEXTURE_SIZE = CGSize(width: DefaultTileData.size.width*2, height: DefaultTileData.size.height*2)
    static let TILE_SIZE: CGSize = CGSize(width: DefaultTileData.size.width, height: DefaultTileData.size.height)
    static let ATTACK_RANGE: CGFloat = CGFloat(DefaultTileData.size.width * 3)
    static let FIRE_RATE: Int = 20
    static let ATTACK_DAMAGE: Int = 10
    
    static let UPGRADE_DAMAGE_BONUS_PCT: Double = 1.2
    static let UPGRADE_FIRE_RATE_REDUCTION_PCT: Double = 0.8
    static let UPGRADE_RANGE_BONUS_PCT: Double = 1.2
    
    static let MAX_UPGRADE: Int = 5
    
    
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
    
    static let SIZE: CGSize = CGSize(width: 43, height: 43)
    static let BASE_HP: Int = 100
    static let BASE_SPEED: CGFloat = 1.0
    
    static let FAST_HP_MODIFIER = 0.90
    static let HEAVY_HP_MODIFIER = 2.0
    static let FLY_HP_MODIFIER = 0.70
    
    static let FAST_SPEED_MODIFIER: CGFloat = 1.30
    static let HEAVY_SPEED_MODIFIER: CGFloat = 0.80
    static let FLY_SPEED_MODIFIER: CGFloat = 0.80
    
    static let STANDARD_ENEMY_SLOT = 1
    static let HEAVY_ENEMY_SLOT = 2
    static let FAST_ENEMY_SLOT = 1
    static let FLY_ENEMY_SLOT = 1
    
}

//Waves
struct WaveData{
    
    //60 frames 1 second
    //3600 frames 1 minute
    
    static let WAVE_STANDARD_SIZE = 30
    static let SPAWN_STANDARD_TIMER = 60 //Frames (1 second)
    static let WAVE_START_TIME = 18000 //Frames (5 minutes)
    
    static let FAST_ENEMY_LIMIT = 5
    static let HEAVY_ENEMY_LIMIT = 5
    static let FLY_ENEMY_LIMIT = 5
    
}

