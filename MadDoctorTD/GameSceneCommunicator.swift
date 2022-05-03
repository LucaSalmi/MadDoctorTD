//
//  GameSceneCommunicator.swift
//  MadDoctorTD
//
//  Created by Daniel Falkedal on 2022-05-03.
//

import Foundation

class GameSceneCommunicator: ObservableObject {
    
    static let instance = GameSceneCommunicator()
    
    @Published var showFoundationMenu: Bool = false
    
    var currentTile: ClickableTile? = nil
    
    private init() {}
    
}
