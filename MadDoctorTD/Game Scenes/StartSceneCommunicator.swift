//
//  StartSceneCommunicator.swift
//  MadDoctorTD
//
//  Created by Calle Höglund on 2022-05-11.
//

import Foundation

class StartSceneCommunicator: ObservableObject{
    
    @Published var animateDoors = true
    
    static let instance = StartSceneCommunicator()
    
    private init() {}
    
    
}
