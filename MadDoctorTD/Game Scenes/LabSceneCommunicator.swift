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
