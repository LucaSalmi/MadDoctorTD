//
//  AppManager.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-03.
//

import Foundation

enum AppState: Int{
    
    case startMenu = 0 , labMenu, gameScene, researchMenu, settingsMenu
    
}

class AppManager{
    
    static var appManager = AppManager()
    var state = AppState.startMenu
    
    //SINGLETON
    private init(){}
    
    
}
