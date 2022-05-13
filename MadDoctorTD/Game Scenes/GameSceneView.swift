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
                            
                            Button {
                                AppManager.appManager.state = .labMenu
                                SoundManager.playBGM(bgmString: SoundManager.researchViewAtmosphere)

                            } label: {
                                Text("Research")
                            }

                            Spacer()
                            
                            Button {
                                GameScene.instance!.waveManager!.waveStartCounter = WaveData.WAVE_START_TIME
                                communicator.isBuildPhase = false
                                GameScene.instance!.waveManager!.shouldCreateWave = true
                                GameSceneCommunicator.instance.cancelAllMenus()
                                SoundManager.playBGM(bgmString: SoundManager.desertAmbience)
                                
                            } label: {
                                Text("READY!")
                            }
                            
                            Spacer()

                        }
                    }
                }
            }
            
            if communicator.showFoundationMenu{
                VStack(spacing: 25) {
                    Text("Foundation menu")
                    Button {
                        communicator.buildFoundation()
                        //SoundManager.playSFX(sfxName: SoundManager.buildingPlacementSFX)
                        SoundManager.playSFX(sfxName: SoundManager.foundationPlacementSFX, scene: GameScene.instance!)

                        //ADD CODE FOR BUILDINGSOUND
                        
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
                    }.disabled(gameManager.rapidFireTowerUnlocked ? false : true)
                    Button {
                        communicator.buildTower(type: TowerTypes.cannonTower)
                    } label: {
                        Text("Build Cannon Tower")
                    }.disabled(gameManager.cannonTowerUnlocked ? false : true)
                    Button {
                        communicator.buildTower(type: TowerTypes.sniperTower)
                    } label: {
                        Text("Build Sniper Tower")
                    }.disabled(gameManager.sniperTowerUnlocked ? false : true)

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
