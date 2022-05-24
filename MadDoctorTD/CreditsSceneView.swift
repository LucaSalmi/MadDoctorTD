//
//  CreditsSceneView.swift
//  MadDoctorTD
//
//  Created by Calle Höglund on 2022-05-24.
//

import Foundation
import SwiftUI
import SpriteKit

struct CreditsSceneView: View{
    
    var creditsScene: SKScene?
    
    init(){
        
        if creditsScene == nil{
            
            creditsScene = SKScene(fileNamed: "CreditsScene")
        }
        
    }
    
    var body: some View{
        
        SpriteView(scene: creditsScene!)
            .edgesIgnoringSafeArea(.all)
        
    }
    
}
