//
//  GameSceneView.swift
//  MadDoctorTD
//
//  Created by Daniel Falkedal on 2022-05-03.
//

import SwiftUI
import SpriteKit

struct GameSceneView: View {
    
    var gameScene: SKScene
    
    init() {
        gameScene = SKScene(fileNamed: "GameScene")!
        gameScene.scaleMode = .fill
    }

    var body: some View {
        SpriteView(scene: gameScene)
            .ignoresSafeArea()
    }

    
}
