//
//  MainMenu.swift
//  MadDoctorTD
//
//  Created by Calle Höglund on 2022-05-03.
//

import SwiftUI

struct MainMenuView: View {
    var body: some View {
        
        
        VStack{
            
            Text("Mad TD")
                .font(.largeTitle)
            
            Button {
                // TODO: NEW GAME
            } label: {
                Label("New Game", systemImage: "play.circle")
                
            }.padding()
            
            Button {
                // TODO: LOAD GAME
            } label: {
                Label("Load Game", systemImage: "opticaldisc")
                
            }.padding()
            
            Button {
                //TODO: GO TO SETTINGS HERE.
            } label: {
                Label("Settings", systemImage: "gearshape.circle")
            }.padding()
            
        }
        .font(.title)
        
        
    }
}

