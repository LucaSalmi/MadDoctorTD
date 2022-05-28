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
    
    @Published var image2a = "power_upgrade_2"
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
    
    @Published var toastOpacity: Double = Double(0.0)
    let defaultToastPositionY: Double = Double((UIScreen.main.bounds.height - UIScreen.main.bounds.height/8))
    @Published var toastPositionY: Double = Double(0.0)
    @Published var toastViewHeader: String = "Toast View"
    @Published var toastViewText: String = "This is the toast view"
    
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
            //displayInfoView(title: "Success", description: "You unlocked this upgrade for \(selectedTowerType)")
            displayToastView(title: "Success", description: "You unlocked this upgrade for \(selectedTowerType)")
            if let labScene = LabScene.instance {
                SoundManager.playSFX(sfxName: SoundManager.upgradeUnlocked, scene: labScene, sfxExtension: SoundManager.mp3Extension)
            }
        case .error:
            displayInfoView(title: "Error", description: "Not implemented yet")
        case .pathBlocked:
            displayInfoView(title: "Unavailable", description: "This path is not unlocked yet")
            
        }
        
    }
    
    private func displayToastView(title: String, description: String) {
        
        guard let labScene = LabScene.instance else { return }
        
        toastViewHeader = title
        toastViewText = description
        toastPositionY = UIScreen.main.bounds.height
        toastOpacity = 0.0
        labScene.fadeOutToast = false
        labScene.fadeInToast = true
        
    }
    
    func applyResearch() -> ErrorType {
        
        let gameManager = GameManager.instance
        let communicator = LabSceneCommunicator.instance
        
        switch communicator.selectedTowerType {
            
        case .gunTower:
            
            if LabSceneCommunicator.instance.gunTowerResearchLevel.contains(communicator.selectedTreeButtonId) {
                return .unlocked
            }
            
            switch communicator.selectedTreeButtonId {
            case "1":
                
                return .unlocked
                
            case "2a":
                
                if !LabSceneCommunicator.instance.gunTowerResearchLevel.contains("1") {
                    return .pathBlocked
                }
                LabSceneCommunicator.instance.gunTowerResearchLevel.append(communicator.selectedTreeButtonId)
                gameManager.researchPoints -= 4
                communicator.gunTowerResearchLevel.append(communicator.selectedTreeButtonId)
                return .success
                
            case "3a":
                
                if !LabSceneCommunicator.instance.gunTowerResearchLevel.contains("2a") {
                    return .pathBlocked
                }
                LabSceneCommunicator.instance.gunTowerResearchLevel.append(communicator.selectedTreeButtonId)
                gameManager.researchPoints -= 6
                gameManager.slimeMaterials -= 1
                communicator.gunTowerResearchLevel.append(communicator.selectedTreeButtonId)
                return .success
                
            case "2b":
                
                if !LabSceneCommunicator.instance.gunTowerResearchLevel.contains("1") {
                    return .pathBlocked
                }
                LabSceneCommunicator.instance.gunTowerResearchLevel.append(communicator.selectedTreeButtonId)
                gameManager.researchPoints -= 4
                communicator.gunTowerResearchLevel.append(communicator.selectedTreeButtonId)
                return .success
                
            case "2c":
                
                if !LabSceneCommunicator.instance.gunTowerResearchLevel.contains("1") {
                    return .pathBlocked
                }
                LabSceneCommunicator.instance.gunTowerResearchLevel.append(communicator.selectedTreeButtonId)
                gameManager.researchPoints -= 4
                communicator.gunTowerResearchLevel.append(communicator.selectedTreeButtonId)
                return .success
                
            default:
                print("not implemented")
            }
            
        case .rapidFireTower:
            
            if LabSceneCommunicator.instance.rapidTowerResearchLevel.contains(communicator.selectedTreeButtonId) {
                return .unlocked
            }
            
            switch communicator.selectedTreeButtonId {
            case "1":

                GameScene.instance!.uiManager!.towerUI!.childNode(withName: "SpeedTower")!.alpha = 1
                LabSceneCommunicator.instance.rapidTowerResearchLevel.append(communicator.selectedTreeButtonId)
                gameManager.researchPoints -= 2
                communicator.rapidTowerResearchLevel.append(communicator.selectedTreeButtonId)
                return .success
                
            case "2a":
                
                if !LabSceneCommunicator.instance.rapidTowerResearchLevel.contains("1") {
                    return .pathBlocked
                }
                LabSceneCommunicator.instance.rapidTowerResearchLevel.append(communicator.selectedTreeButtonId)
                gameManager.researchPoints -= 4
                communicator.rapidTowerResearchLevel.append(communicator.selectedTreeButtonId)
                return .success
                
            case "2b":
                
                if !LabSceneCommunicator.instance.rapidTowerResearchLevel.contains("1") {
                    return .pathBlocked
                }
                LabSceneCommunicator.instance.rapidTowerResearchLevel.append(communicator.selectedTreeButtonId)
                gameManager.researchPoints -= 4
                communicator.rapidTowerResearchLevel.append(communicator.selectedTreeButtonId)
                return .success
                
            case "3b":
                
                if !LabSceneCommunicator.instance.rapidTowerResearchLevel.contains("2b") {
                    return .pathBlocked
                }
                LabSceneCommunicator.instance.rapidTowerResearchLevel.append(communicator.selectedTreeButtonId)
                gameManager.researchPoints -= 6
                gameManager.slimeMaterials -= 1
                communicator.rapidTowerResearchLevel.append(communicator.selectedTreeButtonId)
                return .success
                
            case "2c":
                
                if !LabSceneCommunicator.instance.rapidTowerResearchLevel.contains("1") {
                    return .pathBlocked
                }
                LabSceneCommunicator.instance.rapidTowerResearchLevel.append(communicator.selectedTreeButtonId)
                gameManager.researchPoints -= 4
                communicator.rapidTowerResearchLevel.append(communicator.selectedTreeButtonId)
                return .success
                           
            default:
                print("not implemented")
            }
            
        case .sniperTower:
            
            if LabSceneCommunicator.instance.sniperTowerResearchLevel.contains(communicator.selectedTreeButtonId) {
                return .unlocked
            }
            
            switch communicator.selectedTreeButtonId {
            case "1":

                GameScene.instance!.uiManager!.towerUI!.childNode(withName: "SniperTower")!.alpha = 1
                LabSceneCommunicator.instance.sniperTowerResearchLevel.append(communicator.selectedTreeButtonId)
                gameManager.researchPoints -= 2
                communicator.sniperTowerResearchLevel.append(communicator.selectedTreeButtonId)
                return .success
                
            case "2a":
                
                if !LabSceneCommunicator.instance.sniperTowerResearchLevel.contains("1") {
                    return .pathBlocked
                }
                LabSceneCommunicator.instance.sniperTowerResearchLevel.append(communicator.selectedTreeButtonId)
                gameManager.researchPoints -= 4
                communicator.sniperTowerResearchLevel.append(communicator.selectedTreeButtonId)
                return .success
                
            case "2b":
                
                if !LabSceneCommunicator.instance.sniperTowerResearchLevel.contains("1") {
                    return .pathBlocked
                }
                LabSceneCommunicator.instance.sniperTowerResearchLevel.append(communicator.selectedTreeButtonId)
                gameManager.researchPoints -= 4
                communicator.sniperTowerResearchLevel.append(communicator.selectedTreeButtonId)
                return .success
                
            case "3b":
                
                if !LabSceneCommunicator.instance.sniperTowerResearchLevel.contains("2b") {
                    return .pathBlocked
                }
                LabSceneCommunicator.instance.sniperTowerResearchLevel.append(communicator.selectedTreeButtonId)
                gameManager.researchPoints -= 6
                gameManager.slimeMaterials -= 1
                communicator.sniperTowerResearchLevel.append(communicator.selectedTreeButtonId)
                return .success
                
            case "2c":
                
                if !LabSceneCommunicator.instance.sniperTowerResearchLevel.contains("1") {
                    return .pathBlocked
                }
                LabSceneCommunicator.instance.sniperTowerResearchLevel.append(communicator.selectedTreeButtonId)
                gameManager.researchPoints -= 4
                communicator.sniperTowerResearchLevel.append(communicator.selectedTreeButtonId)
                return .success
                
            default:
                print("not implemented")
            }
            
        default:
            
            if LabSceneCommunicator.instance.cannonTowerResearchLevel.contains(communicator.selectedTreeButtonId) {
                return .unlocked
            }
            
            switch communicator.selectedTreeButtonId {
            case "1":

                GameScene.instance!.uiManager!.towerUI!.childNode(withName: "CannonTower")!.alpha = 1
                LabSceneCommunicator.instance.cannonTowerResearchLevel.append(communicator.selectedTreeButtonId)
                gameManager.researchPoints -= 2
                communicator.cannonTowerResearchLevel.append(communicator.selectedTreeButtonId)
                return .success
                
            case "2a":
                
                if !LabSceneCommunicator.instance.cannonTowerResearchLevel.contains("1") {
                    return .pathBlocked
                }
                LabSceneCommunicator.instance.cannonTowerResearchLevel.append(communicator.selectedTreeButtonId)
                gameManager.researchPoints -= 4
                communicator.cannonTowerResearchLevel.append(communicator.selectedTreeButtonId)
                return .success
                
            case "2b":
                
                if !LabSceneCommunicator.instance.cannonTowerResearchLevel.contains("1") {
                    return .pathBlocked
                }
                LabSceneCommunicator.instance.cannonTowerResearchLevel.append(communicator.selectedTreeButtonId)
                gameManager.researchPoints -= 4
                communicator.cannonTowerResearchLevel.append(communicator.selectedTreeButtonId)
                return .success
                
            case "2c":
                
                if !LabSceneCommunicator.instance.cannonTowerResearchLevel.contains("1") {
                    return .pathBlocked
                }
                LabSceneCommunicator.instance.cannonTowerResearchLevel.append(communicator.selectedTreeButtonId)
                gameManager.researchPoints -= 4
                communicator.cannonTowerResearchLevel.append(communicator.selectedTreeButtonId)
                return .success
                
            case "3c":
                
                if !LabSceneCommunicator.instance.cannonTowerResearchLevel.contains("2c") {
                    return .pathBlocked
                }
                LabSceneCommunicator.instance.cannonTowerResearchLevel.append(communicator.selectedTreeButtonId)
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
