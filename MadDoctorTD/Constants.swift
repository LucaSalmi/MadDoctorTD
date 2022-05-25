//
//  Constants.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-03.
//

import Foundation
import SpriteKit


enum AppState: Int{
    
    case startMenu = 0 , labMenu, gameScene, researchMenu, settingsMenu, creditsScene
    
}

enum GameState: Int{
    
    case menus = 0 , build, wave, pause
    
    
}

enum ActionState: Int{
    
    case none = 0, placeFoundation, placeTower, sellTower, upgradeTower 
    
}

enum ErrorType: Int{
    
    case researchPoints = 0, unlocked, success, error
    
}

struct PhysicsCategory{
    
    static let None: UInt32 = 0
    static let All: UInt32 = 0xFFFFFFFF
    static let Edge: UInt32 = 0b1
    static let Foundation: UInt32 = 0b10
    static let Enemy: UInt32 = 0b100
    static let Projectile: UInt32 = 0b1000
    static let Boss: UInt32 = 0b10000
    
}

struct DefaultTileData {
    static let SIZE: CGSize = CGSize(width: 86, height: 86)
}

struct FoundationData{
    
    static let SIZE: CGSize = DefaultTileData.SIZE
    
    static let BASE_COST: Int = 100
    static let REFOUND_FACTOR: Double = 0.8
    static let BASE_HP = 100
    
    static let UPGRADE_HP_FACTOR: Double = 1.5
    static let UPGRADE_PRICE: Int = 100
    static let REPAIR_PRICE_PER_HP: Double = 0.5
    
    static let MAX_UPGRADE: Int = 5
    
}
enum UpgradeTypes: Int{
    case damage = 0, range, firerate
}


enum EnemyTypes: Int{
    case standard = 0, fast, heavy, flying, boss
}

enum EnemyRaces: Int{
    //expand this with more races because variety makes the world better!!! ;)
    case slime = 0, squid
}



//Towers
enum TowerTypes: Int{
    case gunTower = 0, rapidFireTower, sniperTower, cannonTower
}

struct TowerData {
    
    static let TEXTURE_SIZE = CGSize(width: DefaultTileData.SIZE.width*1.2, height: DefaultTileData.SIZE.height*1.2)
    static let POWER_OFF_SIZE = CGSize(width: DefaultTileData.SIZE.width*1.2, height: DefaultTileData.SIZE.height*1.2)
    static let TILE_SIZE: CGSize = CGSize(width: DefaultTileData.SIZE.width, height: DefaultTileData.SIZE.height)
    static let ATTACK_RANGE: CGFloat = CGFloat(DefaultTileData.SIZE.width * 3)
    static let FIRE_RATE: Int = 20
    static let ATTACK_DAMAGE: Int = 10
    
    static let UPGRADE_DAMAGE_BONUS_PCT: Double = 1.2
    static let UPGRADE_FIRE_RATE_REDUCTION_PCT: Double = 0.8
    static let UPGRADE_RANGE_BONUS_PCT: Double = 1.2
    
    static let MAX_UPGRADE: Int = 5
    
    static let BASE_COST: Int = 500
    static let BASE_UPGRADE_COST: Int = 100
    static let COST_MULTIPLIER_PER_LEVEL: Double = 1.2
    static let REFOUND_FACTOR: Double = 0.8
}


//Bullets
enum ProjectileTypes: Int {
    case gunProjectile = 0, rapidFireProjectile, sniperProjectile, bouncingProjectile, mineProjectile, cannonProjectile
}

struct ProjectileData {
    static let size: CGSize = CGSize(width: DefaultTileData.SIZE.width * 0.5, height: DefaultTileData.SIZE.height * 0.5)
    
    static let CANNON_BALL_SIZE: CGSize = CGSize(width: DefaultTileData.SIZE.width * 0.2, height: DefaultTileData.SIZE.height * 0.2)
    //static let speed: CGFloat = CGFloat(8.0)
    static let speed: CGFloat = CGFloat(8.0)
    
    static let SNIPER_MODIFIER: CGFloat = CGFloat(13.0)
    
    static let BOUNCING_PROJECTILE_SPEED = CGFloat(10.0)
    
}

struct AoeProjectileData{
    
    static let BLAST_RADIUS: CGFloat = CGFloat(120)
    
    static let TRAVEL_DURATION: CGFloat = CGFloat(180)
}


//Enemies
struct EnemiesData{
    
    static let SIZE: CGSize = CGSize(width: 43, height: 43)
    static let BASE_HP: Int = 100
    static let BASE_SPEED: CGFloat = 1.5
    
    static let FAST_HP_MODIFIER = 0.90
    static let HEAVY_HP_MODIFIER = 2.0
    static let FLY_HP_MODIFIER = 0.70
    static let BOSS_HP_MODIFIER = 10.0
    
    static let FAST_SPEED_MODIFIER: CGFloat = 1.30
    static let HEAVY_SPEED_MODIFIER: CGFloat = 0.80
    static let FLY_SPEED_MODIFIER: CGFloat = 0.80
    static let BOSS_SPEED_MODIFIER: CGFloat = 0.50
    
    static let STANDARD_ENEMY_SLOT = 1
    static let HEAVY_ENEMY_SLOT = 2
    static let FAST_ENEMY_SLOT = 1
    static let FLY_ENEMY_SLOT = 1
    static let BOSS_ENEMY_SLOT = WaveData.LEVEL_WAVE_SIZE
    
    static let BASE_KILL_VALUE = 25
    
    static let SLIME_ARMOUR_VALUE = 2
    static let SQUID_ARMOUR_VALUE = 3
    
    static let BASE_ATTACK_POWER_VALUE = 20
    static let BASE_ATTACK_SPEED_VALUE = 60 //in frames per second
    
    static let BASE_DAMAGE_VALUE = 1
    static let BOSS_DAMAGE_VALUE = 5
    
}

//Waves
struct WaveData{
    
    static let LEVEL_WAVE_SIZE = 5
    //60 frames 1 second
    //3600 frames 1 minute
    static let WAVE_STANDARD_SIZE = 4
    static let SPAWN_STANDARD_TIMER = 60 //60 frames = 1 second
    static let WAVE_START_TIME = 900 //900 frames = 15 seconds
    
    static let FAST_ENEMY_LIMIT = 5
    static let HEAVY_ENEMY_LIMIT = 5
    static let FLY_ENEMY_LIMIT = 5
    
    static let INCOME_PER_WAVE = 150
    
    static let MAX_ATTACKER_NUMBER = 1
    
}


//Player + Economy
struct PlayerData{
    
    static let START_MONEY = 2500 //2500 //!2000
    static let BASE_HP = 10 //3
    static let START_RESEARCH_POINTS = 3

}


struct UIData{
    static let INACTIVE_BUTTON_ALPHA = 0.5
    static let BUILD_BUTTONS_UI_POS_X: CGFloat = CGFloat(315)
    static let BUILD_BUTTONS_UI_SPEED: CGFloat = CGFloat(15.0)
}


struct LabData{
    
    static let UPGRADE_COST_1 = 1
    static let UPGRADE_COST_2 = 2
    static let UPGRADE_COST_3 = 3
    static let UPGRADE_COST_4 = 4
    
    static func getCost(selected: String) -> Int{
        
        switch selected{
            
        case "1":
            return LabData.UPGRADE_COST_1
            
        case "2":
            return LabData.UPGRADE_COST_2
            
        case "3a":
            return LabData.UPGRADE_COST_3
            
        case "3b":
            return LabData.UPGRADE_COST_4
            
        case "4a":
            return LabData.UPGRADE_COST_3
            
        case "4b":
            return LabData.UPGRADE_COST_4
            
        case "5a":
            return LabData.UPGRADE_COST_3
            
        case "5b":
            return LabData.UPGRADE_COST_4
            
        default:
            return LabData.UPGRADE_COST_1
        }
        
    }
    
}

