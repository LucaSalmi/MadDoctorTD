//
//  GameOverView.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-13.
//

import SwiftUI

struct GameOverView: View {
    var body: some View {
        VStack{
            
            Text("Game Over")
                .font(.title)
            
            Button {
                GameScene.instance?.resetGameScene()
                GameSceneCommunicator.instance.cancelAllMenus()
                GameScene.instance?.gameSetup()
            } label: {
                Text("Restart")
            }
            
            Button {
                GameScene.instance?.resetGameScene()
                GameSceneCommunicator.instance.cancelAllMenus()
                AppManager.appManager.state = .startMenu
            } label: {
                Text("Main Menu")
            }


            
            
            
        }
    }
}


