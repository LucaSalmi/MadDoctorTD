//
//  AppManager.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-03.
//

import Foundation

class AppManager: ObservableObject{
    
    static var appManager = AppManager()
    @Published var state = AppState.startMenu
    
    @Published var transitionOpacity: Double = 0.0
    
    //SINGLETON
    private init(){}
    
    
}
