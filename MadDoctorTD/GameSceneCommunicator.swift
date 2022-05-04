//
//  GameSceneCommunicator.swift
//  MadDoctorTD
//
//  Created by Daniel Falkedal on 2022-05-03.
//

import Foundation
import GameplayKit

class GameSceneCommunicator: ObservableObject {
    
    static let instance = GameSceneCommunicator()
    
    @Published var showFoundationMenu: Bool = false
    
    var currentTile: ClickableTile? = nil
    
    private init() {}
    
    func buildFoundation() {
        
        currentTile!.containsFoundation = true
        currentTile!.color = .clear
        
        
        let foundation = FoundationPlate(position: currentTile!.position)
        GameScene.instance!.foundationPlatesNode.addChild(foundation)        
        
        currentTile = nil
        showFoundationMenu = false
        
    }
    
    func cancelFoundation() {
        
        currentTile!.color = .clear
        currentTile = nil
        showFoundationMenu = false
        
    }
    
}
