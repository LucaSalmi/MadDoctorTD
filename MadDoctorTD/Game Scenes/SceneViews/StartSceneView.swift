//
//  StartSceneView.swift
//  MadDoctorTD
//
//  Created by Calle Höglund on 2022-05-11.
//

import SwiftUI
import SpriteKit

struct StartSceneView: View {
    
    
    static var startScene: SKScene?
    
    init() {
        if StartSceneView.startScene == nil{
            StartSceneView.startScene = SKScene(fileNamed: "StartScene")!
        }
        StartSceneView.startScene!.scaleMode = .fill
    }

    var body: some View {
        SpriteView(scene: StartSceneView.startScene!)
            .ignoresSafeArea()        
    }
        //.onAppear(perform: SoundManager.playBGM(bgmString: SoundManager.filteredMainThemeBackgroundMusic))
}


