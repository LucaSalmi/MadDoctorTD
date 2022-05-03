//
//  ResearchView.swift
//  MadDoctorTD
//
//  Created by Calle Höglund on 2022-05-03.
//

import SwiftUI

struct ResearchView: View {
    var body: some View {
        
        VStack(spacing: 40){
            
            Text("Upgrades")
                .font(.largeTitle)
            
            Button {
                //TODO: DO SOMETHING HERE
            } label: {
                ResearchItem(researchInfo: "Increase cash value of kills by 10%", imageName: "dollarsign.circle")
            }
            
            Button {
                //TODO: DO SOMETHING HERE
            } label: {
                ResearchItem(researchInfo: "Increase damage of towers by 10%", imageName: "dollarsign.circle")
            }
            
            Button {
                //TODO: DO SOMETHING HERE
            } label: {
                ResearchItem(researchInfo: "Increase attackspeed of towers by 10%", imageName: "dollarsign.circle")
            }
            
            Button {
                //TODO: DO SOMETHING HERE
            } label: {
                ResearchItem(researchInfo: "Increase range of towers by 10%", imageName: "dollarsign.circle")
            }
            
            
            

            
            
            
            
            
            
            
            
            
        }
        
        
    }
}

struct ResearchItem: View{
    
    var researchInfo: String
    var imageName: String
    
    var body: some View{
        HStack{
            Image(systemName: imageName)
            
            Text(researchInfo)
        }
        
        
        
    }
    
}
