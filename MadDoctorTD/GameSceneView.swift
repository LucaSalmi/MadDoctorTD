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
                    
                    GameScene.instance?.isWaveActive = true
                        
                    
                } label: {
                    Text("MOVE!")
                }

            }
            
            if communicator.showFoundationMenu{
                VStack(spacing: 25) {
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

                }.font(.title)
            }
            if communicator.showTowerMenu{
                
                VStack(spacing: 25) {
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
                    }.disabled(GameScene.instance!.isWaveActive ? true : false)
                    Button {
                        communicator.cancelAllMenus()
                    } label: {
                        Text("Cancel")
                    }

                }.font(.title)
                
            }
            if communicator.showUpgradeMenu{
                
                VStack(spacing: 25){
                    Text("Upgrade menu")
                    Button {
                        communicator.currentTower!.upgradeDamage()
                    } label: {
                        Text("Upgrade damage")
                    }
                    Button {
                        communicator.currentTower!.upgradeRange()
                    } label: {
                        Text("Upgrade range")
                    }
                    Button {
                        communicator.currentTower!.upgradeAttackSpeed()
                    } label: {
                        Text("Upgrade attack speed")
                    }
                    Button {
                        communicator.sellTower()
                    } label: {
                        Text("Sell tower")
                    }

                }.font(.title)
            }
        }
    }

    
}
