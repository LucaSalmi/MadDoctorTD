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
        labScene = SKScene(fileNamed: "LabScene")!
        labScene.scaleMode = .fill
    }

    var body: some View {
        SpriteView(scene: labScene)
            .ignoresSafeArea()
    }
}
