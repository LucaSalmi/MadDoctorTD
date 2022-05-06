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
        communicator.cancelAllMenus()
    }

    var body: some View {
        ZStack {
            SpriteView(scene: gameScene)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Button {
                    
                    GameScene.instance?.waveStartCounter = WaveData.WAVE_START_TIME
                        
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
                        communicator.buildTower(type: TowerTypes.rapidFireTower.rawValue)
                    } label: {
                        Text("Build Rapid Fire Tower")
                    }
                    
                    Button {
                        communicator.buildTower(type: TowerTypes.sniperTower.rawValue)
                    } label: {
                        Text("Build Sniper Tower")
                    }

                    Button {
                        communicator.sellFoundation()
                    } label: {
                        Text("Sell Foundation")
                    }.disabled(GameScene.instance!.isWaveActive ? true : false)
                        .disabled(communicator.currentFoundation!.isStartingFoundation ? true : false)
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
                        
                        communicator.currentTower!.upgrade(upgradeType: .damage)
                    } label: {
                        Text("Upgrade damage")
                    }
                    Button {
                        communicator.currentTower!.upgrade(upgradeType: .range)
                    } label: {
                        Text("Upgrade range")
                    }
                    Button {
                        communicator.currentTower!.upgrade(upgradeType: .firerate)
                    } label: {
                        Text("Upgrade attack speed")
                    }
                    Button {
                        communicator.sellTower()
                        
                    } label: {
                        Text("Sell tower")
                    }

                }.font(.title)
                    .foregroundColor(communicator.currentTower!.upgradeCount <= TowerData.MAX_UPGRADE ? Color.white : Color.gray)
                    
            }
        }
    }

    
}
