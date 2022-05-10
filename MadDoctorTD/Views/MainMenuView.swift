//
//  MainMenu.swift
//  MadDoctorTD
//
//  Created by Calle Höglund on 2022-05-03.
//
import SwiftUI

struct MainMenuView: View {
    
    
    @ObservedObject var appManager = AppManager.appManager
    
    
    var body: some View {
        
        
        VStack{
            
            Text("Mad TD")
                .font(.largeTitle)
            
            Button {
                appManager.state = .gameScene
            } label: {
                Label("New Game", systemImage: "play.circle")
                
            }.padding()
            
            Button {
                appManager.state = .gameScene
            } label: {
                Label("Load Game", systemImage: "opticaldisc")
                
            }.padding()
            
            Button {
                //TODO: GO TO SETTINGS HERE.
                appManager.state = .settingsMenu
            } label: {
                Label("Settings", systemImage: "gearshape.circle")
            }.padding()
            
        }
        .font(.title)
        
        
    }
}
