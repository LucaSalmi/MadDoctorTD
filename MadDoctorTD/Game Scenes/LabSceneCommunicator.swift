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
    
}
