//
//  LabSceneView.swift
//  MadDoctorTD
//
//  Created by Daniel Falkedal on 2022-05-03.
//

import SwiftUI
import SpriteKit

struct LabSceneView: View {
    
    var labScene: SKScene
    
    init() {
        if LabScene.instance == nil {
            labScene = SKScene(fileNamed: "LabScene")!
        }
        else {
            labScene = LabScene.instance!
        }
        labScene.scaleMode = .fill
    }

    var body: some View {
        ZStack {
            SpriteView(scene: labScene)
                .ignoresSafeArea()
            
            VStack {
                Button {
                    AppManager.appManager.state = .gameScene
                } label: {
                    Text("Return")
                }

            }
        }
    }
}
