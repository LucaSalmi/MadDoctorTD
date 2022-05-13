//
//  SettingsView.swift
//  MadDoctorTD
//
//  Created by Calle Höglund on 2022-05-03.
//
import SwiftUI

struct SettingsView: View {
    
    var title: String
    @ObservedObject var appManager = AppManager.appManager
    @ObservedObject var gameManager = GameManager.instance
    
    
    var body: some View {
        VStack(spacing: 40){
            
            Text(title)
                .font(.largeTitle)
            
            Toggle("Music", isOn: $gameManager.isMusicOn)
                .onChange(of: gameManager.isMusicOn) { value in
                    if !gameManager.isMusicOn {
                        SoundManager.stopMusic()
                    }
                }
            
            Toggle("SFX", isOn: $gameManager.isSfxOn)
            
            
                
                Button {
                    if !gameManager.isPaused{
                        appManager.state = .startMenu
                    }else{
                        gameManager.isPaused = false
                    }
                    
                } label: {
                    Text("Return")
                        .font(.title)
                }

                
            
            
            

        }
        .toggleStyle(.button)
        .tint(.cyan)
        .font(.title)
        
        
        
        
    }
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//    }
//}
