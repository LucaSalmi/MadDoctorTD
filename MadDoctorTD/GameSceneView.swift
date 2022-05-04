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
        gameScene.scaleMode = .aspectFit
    }

    var body: some View {
        ZStack {
            SpriteView(scene: gameScene)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Button {
                    GameScene.instance!.player.movePlayerToGoal()
                } label: {
                    Text("MOVE!")
                }

            }
            
            if communicator.showFoundationMenu{
                VStack {
                    Text("Foundation menu")
                    Button {
                        communicator.buildFoundation()
                    } label: {
                        Text("Build foundation")
                    }
                    Button {
                        communicator.cancelFoundationBuild()
                    } label: {
                        Text("Cancel")
                    }

                }
            }
            if communicator.showTowerMenu{
                
                VStack(spacing: 50) {
                    Text("Tower menu")
                    Button {
                        communicator.buildTower(type: TowerTypes.gunTower.rawValue)
                    } label: {
                        Text("Build Gun Tower")
                    }
                    Button {
                        communicator.sellFoundation()
                    } label: {
                        Text("Sell Foundation")
                    }
                    Button {
                        communicator.cancelAllMenus()
                    } label: {
                        Text("Cancel")
                    }

                }.font(.title)
                
            }
            if communicator.showUpgradeMenu{
                
                VStack{
                    Text("Upgrade menu")
                    Button {
                        communicator.sellTower()
                        
                    } label: {
                        Text("Sell tower")
                    }

                }
            }
        }
    }

    
}
