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
    @ObservedObject var gameManager = GameManager.instance
    
    init() {
        
        if GameScene.instance == nil {
            gameScene = SKScene(fileNamed: "GameScene")!
        }
        else {
            gameScene = GameScene.instance!
        }
        gameScene.scaleMode = .aspectFit
        communicator.cancelAllMenus()
    }

    var body: some View {
        ZStack {
            SpriteView(scene: gameScene)
                .ignoresSafeArea()
            
            VStack {
                
                HStack {
                    
                    Text("$ = \(gameManager.currentMoney)")
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button {
                        GameScene.instance?.waveStartCounter = WaveData.WAVE_START_TIME
                    } label: {
                        Text("Start wave!")
                    }
                    
                    Spacer()
                    
                    Text("Current wave = ")
                        .foregroundColor(.white)
                }
                Spacer()
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
                        communicator.buildTower(type: TowerTypes.gunTower)
                    } label: {
                        Text("Build Gun Tower")
                    }
                    Button {
                        communicator.buildTower(type: TowerTypes.rapidFireTower)
                    } label: {
                        Text("Build Rapid Fire Tower")
                    }
                    
                    Button {
                        communicator.buildTower(type: TowerTypes.sniperTower)
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
                        communicator.upgradeTower(upgradeType: .damage)
                    } label: {
                        Text("Upgrade damage")
                    }
                    Button {
                        communicator.upgradeTower(upgradeType: .range)
                    } label: {
                        Text("Upgrade range")
                    }
                    Button {
                        communicator.upgradeTower(upgradeType: .firerate)
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
