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
    
    @ObservedObject var communicator = GameSceneCommunicator.instance
    
    init() {
        gameScene = SKScene(fileNamed: "GameScene")!
        gameScene.scaleMode = .fill
    }

    var body: some View {
        ZStack {
            SpriteView(scene: gameScene)
                .ignoresSafeArea()
            
            if communicator.showFoundationMenu {
                VStack {
                    Text("Foundation menu")
                    Button {
                        communicator.buildFoundation()
                    } label: {
                        Text("Build foundation")
                    }
                    Button {
                        communicator.cancelFoundation()
                    } label: {
                        Text("Cancel")
                    }

                }
            }
        }
    }

    
}
