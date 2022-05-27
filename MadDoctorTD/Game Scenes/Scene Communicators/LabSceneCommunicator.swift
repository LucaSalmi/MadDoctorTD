//
//  LabSceneCommunicator.swift
//  MadDoctorTD
//
//  Created by Daniel Falkedal on 2022-05-12.
//

import Foundation
import SwiftUI

class LabSceneCommunicator: ObservableObject{
    
    @Published var selectedTowerType: TowerTypes = .gunTower
    @Published var selectedTowerImage = "blast_tower"
    
    @Published var gunTowerResearchLevel: [String] = ["1"]
    @Published var rapidTowerResearchLevel = [String]()
    @Published var sniperTowerResearchLevel = [String]()
    @Published var cannonTowerResearchLevel = [String]()
    
    @Published var selectedTreeButtonId: String = "1"
    
    @Published var image2a = "damage_upgrade_2"
    @Published var image3a = "Daniel"
    @Published var image2b = "speed_upgrade_2"
    @Published var image3b = "Daniel"
    @Published var image2c = "range_upgrade_2"
    @Published var image3c = "Daniel"
    
    @Published var showInfoView: Bool = false
    @Published var infoViewHeader: String = "Info View"
    @Published var infoViewText: String = "This is the info view"
    
    @Published var showConfirmView: Bool = false
    @Published var confirmViewHeader: String = "Confirm View"
    @Published var confirmViewText: String = "This is the confirm view"
    
    static let instance = LabSceneCommunicator()
    
    private init() {}
    
    func selectType(type: TowerTypes) {
        
        selectedTowerType = type
        
        switch type {
            
        case .gunTower:
            selectedTowerImage = "blast_tower"
        case .rapidFireTower:
            selectedTowerImage = "speed_tower"
        case .sniperTower:
            selectedTowerImage = "sniper_tower_rotate"
        default:
            selectedTowerImage = "cannon_tower"
            
        }
        
    }
    
    func buyUpgrade(){
        
        let answer = applyResearch()
        switch answer{
            
        case .researchPoints:
            displayInfoView(title: "Insufficient Funds", description: "Not enough Research point")
        case .unlocked:
            displayInfoView(title: "Info", description: "Upgrade already unlocked")
        case .success:
            displayInfoView(title: "Success", description: "You unlocked this upgrade for \(selectedTowerType)")
            if let labScene = LabScene.instance {
                SoundManager.playSFX(sfxName: SoundManager.upgradeUnlocked, scene: labScene, sfxExtension: SoundManager.mp3Extension)
            }
        case .error:
            displayInfoView(title: "Error", description: "Not implemented yet")
        case .pathBlocked:
            displayInfoView(title: "Unavailable", description: "This path is not unlocked yet")
            
        }
        
    }
    
    func applyResearch() -> ErrorType {
        
        let gameManager = GameManager.instance
        let communicator = LabSceneCommunicator.instance
        
        switch communicator.selectedTowerType {
            
        case .gunTower:
            switch communicator.selectedTreeButtonId {
            case "1":
                return .unlocked
                
            case "2a":
                if gameManager.gunTowerDamageUnlocked {
                    return .unlocked
                }
                gameManager.gunTowerDamageUnlocked = true
                gameManager.researchPoints -= 4
                communicator.gunTowerResearchLevel.append(communicator.selectedTreeButtonId)
                return .success
                
            case "3a":
                if !gameManager.gunTowerDamageUnlocked {
                    return .pathBlocked
                }
                if gameManager.bouncingProjectilesUnlocked {
                    return .unlocked
                }
                gameManager.bouncingProjectilesUnlocked = true
                gameManager.researchPoints -= 6
                gameManager.slimeMaterials -= 1
                communicator.gunTowerResearchLevel.append(communicator.selectedTreeButtonId)
                return .success
                
            case "2b":
                if gameManager.gunTowerSpeedUnlocked {
                    return .unlocked
                }
                gameManager.gunTowerSpeedUnlocked = true
                gameManager.researchPoints -= 4
                communicator.gunTowerResearchLevel.append(communicator.selectedTreeButtonId)
                return .success
                
            case "2c":
                if gameManager.gunTowerRangeUnlocked {
                    return .unlocked
                }
                gameManager.gunTowerRangeUnlocked = true
                gameManager.researchPoints -= 4
                communicator.gunTowerResearchLevel.append(communicator.selectedTreeButtonId)
                return .success
                
            default:
                print("not implemented")
            }
        case .rapidFireTower:
            switch communicator.selectedTreeButtonId {
            case "1":
                if gameManager.rapidFireTowerUnlocked {
                    return .unlocked
                }
                GameScene.instance!.towerUI!.childNode(withName: "SpeedTower")!.alpha = 1
                gameManager.rapidFireTowerUnlocked = true
                gameManager.researchPoints -= 2
                communicator.rapidTowerResearchLevel.append(communicator.selectedTreeButtonId)
                return .success
                
            case "2a":
                if !gameManager.rapidFireTowerUnlocked {
                    return .pathBlocked
                }
                if gameManager.rapidFireTowerDamageUnlocked {
                    return .unlocked
                }
                gameManager.rapidFireTowerDamageUnlocked = true
                gameManager.researchPoints -= 4
                communicator.rapidTowerResearchLevel.append(communicator.selectedTreeButtonId)
                return .success
                
            case "2b":
                if !gameManager.rapidFireTowerUnlocked {
                    return .pathBlocked
                }
                if gameManager.rapidFireTowerSpeedUnlocked {
                    return .unlocked
                }
                gameManager.rapidFireTowerSpeedUnlocked = true
                gameManager.researchPoints -= 4
                communicator.rapidTowerResearchLevel.append(communicator.selectedTreeButtonId)
                return .success
                
            case "3b":
                if !gameManager.rapidFireTowerSpeedUnlocked {
                    return .pathBlocked
                }
                if gameManager.slowProjectilesUnlocked {
                    return .unlocked
                }
                gameManager.slowProjectilesUnlocked = true
                gameManager.researchPoints -= 6
                gameManager.slimeMaterials -= 1
                communicator.rapidTowerResearchLevel.append(communicator.selectedTreeButtonId)
                return .success
                
            case "2c":
                if !gameManager.rapidFireTowerUnlocked {
                    return .pathBlocked
                }
                if gameManager.rapidFireTowerRangeUnlocked {
                    return .unlocked
                }
                gameManager.rapidFireTowerRangeUnlocked = true
                gameManager.researchPoints -= 4
                communicator.rapidTowerResearchLevel.append(communicator.selectedTreeButtonId)
                return .success
                           
            default:
                print("not implemented")
            }
        case .sniperTower:
            switch communicator.selectedTreeButtonId {
            case "1":
                if gameManager.sniperTowerUnlocked {
                    return .unlocked                }
                GameScene.instance!.towerUI!.childNode(withName: "SniperTower")!.alpha = 1
                gameManager.sniperTowerUnlocked = true
                gameManager.researchPoints -= 2
                communicator.sniperTowerResearchLevel.append(communicator.selectedTreeButtonId)
                return .success
                
            case "2a":
                if !gameManager.sniperTowerUnlocked {
                    return .pathBlocked
                }
                if gameManager.sniperTowerDamageUnlocked {
                    return .unlocked
                }
                gameManager.sniperTowerDamageUnlocked = true
                gameManager.researchPoints -= 4
                communicator.sniperTowerResearchLevel.append(communicator.selectedTreeButtonId)
                return .success
                
            case "2b":
                if !gameManager.sniperTowerUnlocked {
                    return .pathBlocked
                }
                if gameManager.sniperTowerSpeedUnlocked {
                    return .unlocked
                }
                gameManager.sniperTowerSpeedUnlocked = true
                gameManager.researchPoints -= 4
                communicator.sniperTowerResearchLevel.append(communicator.selectedTreeButtonId)
                return .success
                
            case "3b":
                if !gameManager.sniperTowerSpeedUnlocked {
                    return .pathBlocked
                }
                if gameManager.poisonProjectilesUnlocked {
                    return .unlocked
                }
                gameManager.poisonProjectilesUnlocked = true
                gameManager.researchPoints -= 6
                gameManager.slimeMaterials -= 1
                communicator.sniperTowerResearchLevel.append(communicator.selectedTreeButtonId)
                return .success
                
            case "2c":
                if !gameManager.sniperTowerUnlocked {
                    return .pathBlocked
                }
                if gameManager.sniperTowerRangeUnlocked {
                    return .unlocked
                }
                gameManager.sniperTowerRangeUnlocked = true
                gameManager.researchPoints -= 4
                communicator.sniperTowerResearchLevel.append(communicator.selectedTreeButtonId)
                return .success
                
            default:
                print("not implemented")
            }
        default:
            switch communicator.selectedTreeButtonId {
            case "1":
                if gameManager.cannonTowerUnlocked {
                    return .unlocked
                }
                GameScene.instance!.towerUI!.childNode(withName: "CannonTower")!.alpha = 1
                gameManager.cannonTowerUnlocked = true
                gameManager.researchPoints -= 2
                communicator.cannonTowerResearchLevel.append(communicator.selectedTreeButtonId)
                return .success
                
            case "2a":
                if !gameManager.cannonTowerUnlocked {
                    return .pathBlocked
                }
                if gameManager.cannonTowerDamageUnlocked {
                    return .unlocked
                }
                gameManager.cannonTowerDamageUnlocked = true
                gameManager.researchPoints -= 4
                communicator.cannonTowerResearchLevel.append(communicator.selectedTreeButtonId)
                return .success
                
            case "2b":
                if !gameManager.cannonTowerUnlocked {
                    return .pathBlocked
                }
                if gameManager.cannonTowerSpeedUnlocked {
                    return .unlocked
                }
                gameManager.cannonTowerSpeedUnlocked = true
                gameManager.researchPoints -= 4
                communicator.cannonTowerResearchLevel.append(communicator.selectedTreeButtonId)
                return .success
                
            case "2c":
                if !gameManager.cannonTowerUnlocked {
                    return .pathBlocked
                }
                if gameManager.cannonTowerRangeUnlocked {
                    return .unlocked
                }
                gameManager.cannonTowerRangeUnlocked = true
                gameManager.researchPoints -= 4
                communicator.cannonTowerResearchLevel.append(communicator.selectedTreeButtonId)
                return .success
                
            case "3c":
                if !gameManager.cannonTowerRangeUnlocked {
                    return .pathBlocked
                }
                if gameManager.mineProjectilesUnlocked {
                    return .unlocked
                }
                gameManager.mineProjectilesUnlocked = true
                gameManager.researchPoints -= 6
                gameManager.slimeMaterials -= 1
                communicator.cannonTowerResearchLevel.append(communicator.selectedTreeButtonId)
                return .success
                
            default:
                print("not implemented")
            }
        }
        return .error
    }
    
    func displayInfoView(title: String, description: String) {
        
        infoViewHeader = title
        infoViewText = description
        showInfoView = true
        
    }
    
}
