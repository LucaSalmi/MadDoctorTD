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
        gameScene.scaleMode = .aspectFill
        communicator.cancelAllMenus()

    }

    var body: some View {

        ZStack {
            SpriteView(scene: gameScene)
                .ignoresSafeArea()
                .blur(radius: gameManager.isPaused ? 5 : 0)
            
            VStack {
                
                if gameManager.isPaused {
                    
                    VStack(spacing: 20){
                        SettingsView(title: "Paused")
                        
                        Button {
                            AppManager.appManager.state = .startMenu
                        } label: {
                            Text("Main Menu")
                        }
                        

                    }.padding(50)
                        .background(Color.white.opacity(0.5))
                    
                        
                }else if GameManager.instance.isGameOver{
                    
                    GameOverView()
                    
                }
                else {
                    HStack {
                        
                        Spacer()
                        
                        Text("$ = \(gameManager.currentMoney)")
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button {
                            communicator.cancelAllMenus()
                            withAnimation{
                                gameManager.isPaused = true
                            }
                            
                        } label: {
                            Text("Pause")
                        }
                        
                        Spacer()
                        
                        Text("Base HP = \(gameManager.baseHp)")
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("Current wave = \(gameManager.currentWave)")
                            .foregroundColor(.white)
                    }
                    Spacer()
                    
                    //TODO: DISPLAY ALERT WHEN NEW WAVE IS INCOMMING!
                    
                    Spacer()
                    
                    if communicator.isBuildPhase {
                        HStack {
                            
                            Spacer()
                            
                            if !communicator.foundationEditMode {
                                Button {
                                    AppManager.appManager.state = .labMenu
                                    SoundManager.playBGM(bgmString: SoundManager.researchViewAtmosphere)

                                } label: {
                                    Text("Research")
                                }
                            }

                            Spacer()
                            
                            Button {
                                communicator.foundationEditMode.toggle()
                                if communicator.foundationEditMode == false {
                                    communicator.confirmFoundationEdit()
                                }
                                communicator.toggleFoundationGrid()
                            } label: {
                                Text(communicator.foundationEditMode ? "Done" : "Edit")
                            }
                            
                            Spacer()
                            
                            if !communicator.foundationEditMode {
                                Button {
                                    GameScene.instance!.waveManager!.waveStartCounter = WaveData.WAVE_START_TIME
                                    communicator.isBuildPhase = false
                                    GameScene.instance!.waveManager!.shouldCreateWave = true
                                    GameSceneCommunicator.instance.cancelAllMenus()
                                    SoundManager.playBGM(bgmString: SoundManager.desertAmbience)
                                    
                                } label: {
                                    Text("READY!")
                                }
                            }
                            
                            Spacer()

                        }
                    }
                }
            }

            
            if communicator.showTowerMenu{
                
                VStack(spacing: 25) {

                    //Foundation options:
                    Button {
                        communicator.repairFoundation()
                    } label: {
                        Text("Repair Foundation")
                    }.disabled(communicator.isBuildPhase ? false : true)
                        .disabled(communicator.currentFoundation!.isStartingFoundation ? true : false)
                    Button {
                        communicator.upgradeFoundation()
                    } label: {
                        Text("Upgrade Foundation")
                    }.disabled(communicator.isBuildPhase ? false : true)
                        .disabled(communicator.currentFoundation!.isStartingFoundation ? true : false)
                    Button {
                        communicator.sellFoundation()
                    } label: {
                        Text("Sell Foundation")
                    }.disabled(communicator.isBuildPhase ? false : true)
                        .disabled(communicator.currentFoundation!.isStartingFoundation ? true : false)
                    Button {
                        communicator.cancelAllMenus()
                    } label: {
                        Text("Cancel")
                    }

                }.font(.title)
                    .background(.black.opacity(0.5))

                
            }
//            if communicator.showUpgradeMenu{
//                
//                VStack(spacing: 25){
//                    Text("Upgrade menu")
//                    
//                    Button {
//                        communicator.upgradeTower(upgradeType: .damage)
//                    } label: {
//                        Text("Upgrade damage")
//                    }
//                    Button {
//                        communicator.upgradeTower(upgradeType: .range)
//                    } label: {
//                        Text("Upgrade range")
//                    }
//                    Button {
//                        communicator.upgradeTower(upgradeType: .firerate)
//                    } label: {
//                        Text("Upgrade attack speed")
//                    }
//                    Button {
//                        communicator.sellTower()
//                        
//                    } label: {
//                        Text("Sell tower")
//                    }
//                    
//                    //Foundation options:
//                    Button {
//                        communicator.currentFoundation = communicator.currentTower!.builtUponFoundation
//                        communicator.repairFoundation()
//                    } label: {
//                        Text("Repair Foundation")
//                    }
//                    Button {
//                        communicator.currentFoundation = communicator.currentTower!.builtUponFoundation
//                        communicator.upgradeFoundation()
//                    } label: {
//                        Text("Upgrade Foundation")
//                    }
//
//                }.font(.title)
//                    .foregroundColor(communicator.currentTower!.upgradeCount <= TowerData.MAX_UPGRADE ? Color.white : Color.gray)
//                    .background(.black.opacity(0.5))
//                    
//            }
        }
        
    }

    
}
