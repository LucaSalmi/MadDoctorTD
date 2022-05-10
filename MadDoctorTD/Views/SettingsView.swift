//
//  SettingsView.swift
//  MadDoctorTD
//
//  Created by Calle Höglund on 2022-05-03.
//
import SwiftUI

struct SettingsView: View {
    
    var title: String
    
    @State private var soundFxOn = true
    @State private var musicOn = true
    
    var body: some View {
        VStack(spacing: 40){
            
            Text(title)
                .font(.largeTitle)
            
            Toggle("SFX", isOn: $soundFxOn)
            
            Toggle("Music", isOn: $musicOn)
            
            
            if musicOn {
                //TODO: Turn on music here.
            }
            
            if soundFxOn{
                //TODO: Turn on sound here.
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
