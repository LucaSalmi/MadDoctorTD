//
//  LabMenuMenuView.swift
//  MadDoctorTD
//
//  Created by Calle Höglund on 2022-05-03.
//

import SwiftUI

struct LabMenuView: View {
    var body: some View {
        VStack(spacing: 40){
            
            Text("In the Lab yo")
                .font(.largeTitle)
            
            Button {
                //TODO: StartGame action here.
            } label: {
                Label("Start Game", systemImage: "play.circle")
            }
            
            Button{
                //TODO: ResearchView action here. 
            } label: {
                Label("Research", systemImage: "graduationcap")
            }
            
            Button {
                //TODO: Return Action here
            } label: {
                Label("Main Menu", systemImage: "arrow.backward.circle")
            }
            
        }
        .font(.title)
        .tint(.cyan)
    }
}

//struct LabMenuMenuView_Previews: PreviewProvider {
//    static var previews: some View {
//        LabMenuMenuView()
//    }
//}
